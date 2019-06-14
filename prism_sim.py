import subprocess
import os
import pandas as pd
import numpy as np
from numpy import pi, sqrt, exp
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import make_axes_locatable
from matplotlib import animation
from matplotlib import rcParams

dtype = "anim"
tail = 15 # Length of tail in animation"

dir_prism = '/home/dickinsonlab/prism-4.5-linux64/bin/'
dir_model = '/home/dickinsonlab/git/cast_surge/'

init_rng = np.arange(-95, 95+1, 10)

dat = []
long = 0
for x0 in init_rng:
    # Run model via PRISM console
    os.chdir(dir_prism)
    print(dir_prism)
    call_line = ["./prism", # Call PRISM
                     os.path.join(dir_model,"fly.pm"), # Model file
                     "-const",
                     "x0=%i,y0=95,sref=3,cref=1"%x0, # Constant definition
                     "-simpath", # Simulate
                     "deadlock", # Stop condition
                     os.path.join(dir_model,"temp.csv")] # Output location
    print(' '.join(call_line))
    subprocess.call(call_line, shell=False)
    os.chdir(dir_model)
    temp = pd.read_csv('temp.csv', sep=' ').to_numpy()
    temp = temp[None,:,:] # Force 3D array

    # Track longest run length
    lenrun = temp.shape[1]
    long = max(long, lenrun)

    # If first run, save
    if len(dat) == 0:
        dat = temp
    # If not first run, pad all lengths to longest and append
    else:
        if dat.shape[1] < long:
            dat = np.pad(dat, ((0,0),(0,long-dat.shape[1]),(0,0)), 'edge')
        if temp.shape[1] < long:
            temp = np.pad(temp, ((0,0),(0,long-temp.shape[1]),(0,0)), 'edge')
        dat = np.concatenate((dat, temp), axis=0)

# Generate odor map
def od(x, y, m=1/2, sig0=1):
    sig = m*y + sig0
    A = sig0/sig
    z = A * exp(-(x-y/3)**2/(2*sig**2))
    return np.minimum(1, z)

ext = 100
x = np.arange(-ext,ext+1)
y = np.flip(np.arange(0, ext+1), axis=0)
X, Y = np.meshgrid(x, y)
z = od(X, Y, m=0.025, sig0=3)

if dtype == "static":
    
    # Plot odor heatmap & path
    fig = plt.figure()
    ax = fig.gca()
    plot = ax.imshow(z, extent=(min(x),max(x),min(y),max(y)))
    plt.plot(dat[:,4], dat[:,5], 'w')
    ax.set_aspect('equal')
    plt.gca().invert_yaxis()

    divider = make_axes_locatable(ax)
    cax = divider.append_axes("right", size="5%", pad=0.05)
    cbar = plt.colorbar(plot, cax=cax)
    cbar.set_label('Odor Density (a.u.)')

    plt.show()

elif dtype == "anim":

    fig, ax = plt.subplots()
    xpos, ypos = [], []
    alpha = np.linspace(1/tail,1,tail)
    rgba = np.ones((tail,4))
    rgba[:, 3] = alpha
    rgba = np.tile(rgba, (len(init_rng),1))
    
    ax = fig.gca()
    figsize = fig.get_size_inches()*fig.dpi
    plot = ax.imshow(z, extent=(min(x),max(x),min(y),max(y)))
    ln = plt.scatter(np.zeros(tail*len(init_rng)),
                     np.zeros(tail*len(init_rng)),
                     c=rgba, s=7)
    ax.set_aspect('equal')

    divider = make_axes_locatable(ax)
    cax = divider.append_axes("right", size="5%", pad=0.05)
    cbar = plt.colorbar(plot, cax=cax)
    cbar.set_label('Odor Density (a.u.)')
    
    def init():
        ax.set_xlim(-100,100)
        ax.set_ylim(0,100)
        ax.invert_yaxis()
        return ln,

    def update(ix):
        xpos = np.reshape(dat[:, ix-tail:ix, 4], (-1))
        ypos = np.reshape(dat[:, ix-tail:ix, 5], (-1))
        ln.set_offsets(np.concatenate((xpos[:,None], ypos[:,None]), axis=1))
##        plt.savefig('.\\gif\\frame_%04i.png'%ix)
        return ln,
    
    ani = animation.FuncAnimation(fig, update,
                                  frames=np.arange(tail, dat.shape[1]),
                                  init_func=init, blit=True,
                                  interval=1000/60, repeat=False)

    print("Longest: ", long)

    plt.show()

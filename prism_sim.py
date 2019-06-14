import subprocess
import os
import pandas as pd
import numpy as np
from numpy import pi, sqrt, exp
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import make_axes_locatable
from matplotlib.animation import FuncAnimation

dtype = "anim"

dir_prism = 'C:\\Program Files\\prism-4.5\\bin'
dir_model = 'C:\\Users\\Kellan\\Documents\\git\\cast_surge\\PRISM'

# Run model via PRISM console
os.chdir(dir_prism)
subprocess.call(["prism", # Call PRISM
                 os.path.join(dir_model,"fly.pm"), # Model file
                 "-const",
                 "x0=90,y0=100", # Constant definition
                 "-simpath", # Simulate
                 "deadlock", # Stop condition
                 os.path.join(dir_model,"temp.csv")], # Output location
                shell=True)
os.chdir(dir_model)
dat = pd.read_csv('temp.csv', sep=' ').to_numpy()

# Generate odor map
def od(x, y, m=1/2, sig0=1):
    sig = m*y + sig0
    A = sig0/sig
    z = A * exp(-x**2/(2*sig**2))
    print(z)
    return np.minimum(1, z)

ext = 100
x = np.arange(-ext,ext+1)
y = np.flip(np.arange(0, ext+1))
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

    ax = fig.gca()
    plot = ax.imshow(z, extent=(min(x),max(x),min(y),max(y)))
    ln, = plt.plot(0, 50, 'w.')
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


    def update(frame):
        xpos, ypos = dat[frame, 4:6]
        ln.set_data(xpos, ypos)
        return ln,
    
    ani = FuncAnimation(fig, update, frames=np.arange(dat.shape[0]),
                        init_func=init, blit=True,
                        interval=1000/60, repeat=False)

    plt.show()

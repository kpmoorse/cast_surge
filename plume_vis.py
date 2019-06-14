import numpy as np
from numpy import pi, sqrt, exp
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import make_axes_locatable

def od(x, y, m=1/2, sig0=1):
    sig = m*y + sig0
    A = sig0/sig
    z = A * exp(-x**2/(2*sig**2))
    print(z)
    return np.minimum(1, z)

ext = 100
x = np.arange(-ext,ext+1)
y = np.arange(0, ext+1)
X, Y = np.meshgrid(x, y)

z = od(X, Y, m=0.025, sig0=3)
fig = plt.figure()
ax = fig.gca()
plot = ax.imshow(z, extent=(min(x),max(x),min(y),max(y)))
ax.set_aspect('equal')

divider = make_axes_locatable(ax)
cax = divider.append_axes("right", size="5%", pad=0.05)
cbar = plt.colorbar(plot, cax=cax)
cbar.set_label('Odor Density (a.u.)')

plt.show()

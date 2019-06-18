from matplotlib import pyplot as plt
import numpy as np
from numpy import pi
import mpl_toolkits.mplot3d.axes3d as p3
from matplotlib import animation

fig = plt.figure()
ax = p3.Axes3D(fig)

def update(num, data, line):
    data[:,0] += vel*np.cos(data[:,3])
    data[:,1] += vel*np.sin(data[:,3])
    data[:,3] = data[:,3] + np.random.normal(0, 0.25, data.shape[0])
##    line.set_data(data[:2, :num])
##    line.set_3d_properties(data[2, :num])
    line.set_data(data[:, :2].T)
    line.set_3d_properties(data[:, 2].T)

N = 100
data = np.random.rand(N, 3)*2-1 # 3D positions on [-1,1]^3
data = np.concatenate((data, np.random.rand(N, 1)*2*pi), axis=1) # X-Y direction on [0,2*pi]
vel = 0.01

##N = 100
##data = np.array(list(gen(N))).T
line, = ax.plot(data[:,0], data[:,1], data[:,2], '.')

# Setting the axes properties
ax.set_xlim3d([-1.0, 1.0])
ax.set_xlabel('X')

ax.set_ylim3d([-1.0, 1.0])
ax.set_ylabel('Y')

ax.set_zlim3d([-1.0, 1.0])
ax.set_zlabel('Z')

ani = animation.FuncAnimation(fig, update, N, fargs=(data, line), interval=1000/30, blit=False)
#ani.save('matplot003.gif', writer='imagemagick')
plt.show()

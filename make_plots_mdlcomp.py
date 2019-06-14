import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

bi = pd.read_csv('prob_success03-binary.csv').to_numpy()
dg = pd.read_csv('prob_success03-diffguauss.csv').to_numpy()

plt.plot(bi[:,0], bi[:,1], '.-', dg[:,0], dg[:,1], '.-')
plt.ylim([0,1])
plt.xlabel('Initial x-position')
plt.legend(['P[Success], Binary', 'P[Success], Diffusive Gaussian'])

plt.savefig('model_comp.png')
plt.show()

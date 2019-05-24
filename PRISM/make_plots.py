import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

ps = pd.read_csv('prob_success03-binary.csv').to_numpy()
er = pd.read_csv('prob_success03-diffgauss.csv').to_numpy()

plt.plot(ps[:,0], ps[:,1], '.-', er[:,0], er[:,1], '.-')
plt.xlabel('Initial x-position')
plt.ylabel('P[Success]')
plt.legend(['Binary', 'Diffusive Gaussian'])

plt.savefig('model_comp.png')
plt.show()

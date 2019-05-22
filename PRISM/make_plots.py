import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

ps = pd.read_csv('prob_success01.csv').to_numpy()
er = pd.read_csv('end_reward01.csv').to_numpy()

plt.plot(ps[:,0], ps[:,1], '.-', er[:,0], er[:,1]/np.max(er[:,1])*0.95, '.-')
plt.ylim([0,1])
plt.xlabel('Initial x-position')
plt.legend(['P[Success]', 'Scaled mean runtime'])

plt.savefig('exp_plot.png')
plt.show()

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

ps = pd.read_csv('prob_success05-randwalk-09.csv').to_numpy()
er = pd.read_csv('prob_success05-randwalk-07.csv').to_numpy()

plt.plot(ps[:,0], ps[:,1], '.-', er[:,0], er[:,1], '.-')
plt.xlabel('Initial x-position')
plt.ylabel('P[Success]')
plt.legend(['P[fwd]=0.9', 'P[fwd]=0.7'])

plt.savefig('randwalk_comp.png')
plt.show()

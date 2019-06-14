import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

dat = pd.read_csv('end_reward04-ref.csv').to_numpy()

plt.plot(np.arange(2,22,2), dat[1:11,0].astype(float), '.-',
         np.arange(2,22,2), dat[13:23,0].astype(float), '.-')
plt.xlabel('sref')
plt.ylabel('Time to Deadlock')
plt.legend(['cref=0', 'cref=2'])

plt.savefig('refractory_comp2.png')
plt.show()

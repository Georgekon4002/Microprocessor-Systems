import matplotlib.pyplot as plt
import numpy as np

t=np.linspace(0,11999,12000) #t: Πλήθος τεμαχίων
initial_cost=[20000, 10000, 100000, 200000] #Αρχικό κόστος κατασκευής
ics_cost=[10, 30, 2, 1] #Κόστος των ICs
construction_cost=[10, 10, 2, 1] #Κόστος κατασκευής

cost=[]
for i in range(len(initial_cost)):
    c=initial_cost[i] + (ics_cost[i] + construction_cost[i]) * t
    cost.append(c)

labels = ["IC on large board", "FPGAs", "SoC-1 on small board", "SoC-2 on tiny board"]
for i in range(4):
    plt.plot(t, cost[i], label=labels[i])

plt.xlabel('Τεμάχια')
plt.ylabel('Συνολικό κόστος')
plt.title('Καμπύλες Κόστους')
plt.grid()
plt.legend()
plt.show()

cost_perunit=[]
for i in range (len(initial_cost)):
    cpu=(initial_cost[i]/t) + ics_cost[i] + construction_cost[i]
    cost_perunit.append(cpu)

for i in range(4):
    plt.plot(t, cost_perunit[i], label=labels[i])
plt.xlabel('Τεμάχια')
plt.ylabel('Συνολικό κόστος')
plt.yscale('log')
plt.title('Καμπύλες Κόστους ανά τεμάχιο')
plt.grid()
plt.legend()
plt.show()
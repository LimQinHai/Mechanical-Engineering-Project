print("This programme is about the effectiveness of thick wall cylinder.")

Di = int(input("What is the internal diameter of the cylinder? [mm]\n"))
Do = int(input("What is the outer diameter of the cylinder? [mm]\n"))
P_i = int(input("What is the internal pressure of the cylinder? [MPa]\n"))
P_o = int(input("What is the external pressure of the cylinder? [MPa]\n"))
Sigma_Y = int(input("What is the yield strength of the cylinder? [MPa]\n"))
answer = input("Is the cylinder open-end or closed-end?\n")
lower_case_answer= answer.lower()

Ri = Di/2
Ro = Do/2

A=((P_i*Ri**2)-(P_o*Ro**2))/(Ro**2-Ri**2)
B=((P_i-P_o)*(Ri**2)*(Ro**2))/(Ro**2-Ri**2)

Radial_stress_Ri = A-(B/Ri**2)
Radial_stress_Ri = round(Radial_stress_Ri,2)
Hoop_stress_Ri = A+(B/Ri**2)
Hoop_stress_Ri = round(Hoop_stress_Ri,2)
print(f"Radial stress at the inner cylinder = {Radial_stress_Ri} MPa")
print(f"Hoop stress at the inner cylinder = {Hoop_stress_Ri} MPa")

Radial_stress_Ro = A-(B/Ro**2)
Radial_stress_Ro = round(Radial_stress_Ro,2)
Hoop_stress_Ro = A+(B/Ro**2)
Hoop_stress_Ro = round(Hoop_stress_Ro,2)
print(f"Radial stress at the outer cylinder = {Radial_stress_Ro} MPa")
print(f"Hoop stress at the outer cylinder = {Hoop_stress_Ro} MPa")

if lower_case_answer == "closed-end":
    longitudinal_stress = A
    print(f"Longitudinal stress = {longitudinal_stress} MPa")
else:
    longitudinal_stress = 0
    print(f"Longitudinal stress = {longitudinal_stress} MPa")

import math
shear_stress = 0
Sigma_1 = ((Radial_stress_Ri + Hoop_stress_Ri)/2) + math.sqrt(((Radial_stress_Ri - Hoop_stress_Ri)/2)**2 + shear_stress**2)
Sigma_2 = ((Radial_stress_Ri + Hoop_stress_Ri)/2) - math.sqrt(((Radial_stress_Ri - Hoop_stress_Ri)/2)**2 + shear_stress**2)

Sigma_1 = round(Sigma_1,2)
Sigma_2 = round(Sigma_2,2)
print(f"Sigma 1 = {Sigma_1} MPa.")
print(f"Sigma 2 = {Sigma_2} MPa")

# Tresca Criterion
Sigma = Sigma_1 - Sigma_2
if Sigma > Sigma_Y:
    print("The cylinder is yielded based on Tresca criterion.\n")
else:
    print("The cylinder is still elastic and safe based on Tresca criterion.\n")

# Von Mises Criterion
Sigma = (Sigma_1**2) - (Sigma_2*Sigma_1) + (Sigma_2**2)
if Sigma > Sigma_Y**2:
    print("The cylinder is yielded based on Von Mises criterion.\n")
else:
    print("The cylinder is still elastic and safe based on Von Mises criterion.\n\n")

def Table_and_Graph (Di,Do,P_i,P_o):
    Ri = Di/2
    Ro = Do/2
    global Y_list
    Y_list = []
    for n in range(0,5):

        A=((P_i*Ri**2)-(P_o*Ro**2))/(Ro**2-Ri**2)
        B=((P_i-P_o)*(Ri**2)*(Ro**2))/(Ro**2-Ri**2)

        Radial_stress_Ri = A-(B/Ri**2)
        Hoop_stress_Ri = A+(B/Ri**2)

        Radial_stress_Ro = A-(B/Ro**2)
        Hoop_stress_Ro = A+(B/Ro**2)

        if lower_case_answer == "closed-end":
            longitudinal_stress = A

        else:
            longitudinal_stress = 0

        import math
        shear_stress = 0
        Sigma_1 = ((Radial_stress_Ri + Hoop_stress_Ri)/2) + math.sqrt(((Radial_stress_Ri - Hoop_stress_Ri)/2)**2 + shear_stress**2)
        Sigma_2 = ((Radial_stress_Ri + Hoop_stress_Ri)/2) - math.sqrt(((Radial_stress_Ri - Hoop_stress_Ri)/2)**2 + shear_stress**2)

        # Tresca Criterion
        Sigma = Sigma_1 - Sigma_2
        if Sigma > Sigma_Y:
            Result_1 = "Yield"
        else:
            Result_1 = " Elastic"

        # Von Mises Criterion
        Sigma = (Sigma_1**2) - (Sigma_2*Sigma_1) + (Sigma_2**2)
        Von_Mises_equivalent_stress = math.sqrt(Sigma)
        if Sigma > Sigma_Y**2:
            Result_2 = "Yield"
        else:
            Result_2 = " Elastic"

        longitudinal_stress = round(longitudinal_stress,2)
        Sigma_1 = round(Sigma_1,2)
        Sigma_2 = round(Sigma_2, 2)
        Von_Mises_equivalent_stress = round(Von_Mises_equivalent_stress,2)

        t.add_row([P_i,Sigma_1,Sigma_2,Von_Mises_equivalent_stress,Result_1,Result_2,longitudinal_stress])

        Y_list.append(Von_Mises_equivalent_stress)

        P_i=P_i+50

    return Y_list

print("The table below provides 5 different runs using different values of internal pressure.")
from prettytable import PrettyTable
t = PrettyTable(['Internal Pressure[MPa]', 'Sigma_1[MPa]','Sigma_2[MPa]','Von_Mises_equivalent_stress[MPa]','Tresca','Von Mises','Sigma_L[MPa]'])
Table_and_Graph(Di,Do,P_i,P_o)
print(t)

X_list = []
for n in range(0,5):
    X_list.append(P_i)
    P_i += 50

print(f"Internal Pressure : {X_list}")
print(f"Von Mises Equivalent Stresses : {Y_list}")

import matplotlib.pyplot as plt
plt.plot(X_list, Y_list)
plt.xlabel('Internal Pressure [MPa]')
plt.ylabel('Von Mises Equivalent Stresses [MPa]')
plt.title('Von Mises Equivalent Stresses vs Internal Pressure')
plt.show()
# -*- coding: utf-8 -*-
"""
Created on Tue Dec 10 15:17:12 2019

@author: User
"""

import math 
import numpy as np 

# little helper to generate normed vectors
# not safe to use with vanishing vectors! 
def normed(v): 
    l = np.linalg.norm(v) 
    return v/l 
    
def closestpoint(p0,p1,ray0,ray1):
    # Generate projectors from rays
    R0 = np.identity(3)-np.outer(ray0,ray0)
    R1 = np.identity(3)-np.outer(ray1,ray1) 
    # Solve linear system 
    return np.linalg.solve(R0+R1,np.dot(R0,p0)+np.dot(R1,p1)) #numpy.linalg.solve(a,b) in the form ax=b; x=ainv*b

# graphical output requires matplotlib 
graphical_output = True 

# we assume units are mm

# positions of left and right eye in the plane 
eye_l = np.array((-30.0,0.0,0.0)) #eye_l = np.array((0.0,-30.0,0.0))
eye_r = np.array ((30.0,0.0,0.0)) #eye_r = np.array ((0.0,30.0,0.0)) 

# position of object 
lookat = np.array((0.0,0.0,600.0)) #lookat = np.array((600.0,0.0,0.0)) 

# direction between eyes 
eye_base = normed(eye_r-eye_l)

# up direction
# should be orthogonal to eye_base 
up = np.array((0.0,1.0,0.0)) #up = np.array((0.0,0.0,1.0))

# normalized rays from eyes to object 
ray_l = normed(lookat-eye_l)
ray_r = normed(lookat-eye_r) 

# normalized horizontal and vertical directions for the ray connecting eye to object 
hor_l = normed(np.cross(ray_l,up))
ver_l = np.cross(hor_l,ray_l)
hor_r = normed(np.cross(ray_r,up))
ver_r = np.cross(hor_r,ray_r)

# variance of the angular deviation
# we sample angular deviation on a tangent plane 
# and then project back to the sphere 
variance_l = np.radians([1.0,1.0]) #1.5,0.16
variance_r = np.radians([1.0,1.0])

#print eyes and object 
print("Eyes at ",eye_l," , ",eye_r) 

# containers to store x and y positions of 
# intersection of left and right eye ray 

if graphical_output :
    x=[] 
    y=[] 
    
    min_psi=[]
    max_psi = []
    max_s = 0.0
    min_s = np.linalg.norm(0.5*eye_r + 0.5*eye_l-lookat)
    # number of random measurements
    trials = 10000
    
    # center of interest , i .e. average position 
    coi = np.zeros(3) 
    for i in range(trials):
        # change of angles
        # using normal distribution
        psi_l = np.random.normal(0.0,variance_l)
        psi_r = np.random.normal(0.0,variance_r)
        
        # using uniform distribution
        #psi_l = np.random.uniform(−2.0∗variance ,2.0∗variance) 
        #psi_r = np.random.uniform(−2.0∗variance ,2.0∗variance) 
        
        # using laplace distribution
        #psi_l = np.random.laplace(0.0,variance)
        #psi_r = np.random.laplace(0.0,variance) 
        
        # generate the slightly rotated eye rays
        # simply by adding the components along eye and up direction 
        vray_l = normed(ray_l + psi_l[0] *hor_l + psi_l[1] *ver_l) 
        vray_r = normed(ray_r + psi_r[0] *hor_r + psi_r[1] *ver_r) 
        v = closestpoint(eye_l ,eye_r ,vray_l ,vray_r) 
        
        # keep track of centroid of estimated object positions 
        coi += v 
        
        # keep track of smallest and largest distance
        # we simply judge distance by length of s 
        ls = np.linalg.norm(0.5*eye_r+0.5*eye_l-v)
        
        if(ls>max_s):
            max_s = ls 
            max_psi = [psi_l ,psi_r]
        if(ls<min_s): 
            min_s = ls 
            min_psi=[psi_l,psi_r] 
            
            # add to container for drawing
            # projection is onto the plane spanned by the first two comp. 
            
        if graphical_output :
            x.append (v[0])
            y.append (v[1]) 

print("Largest distance:", max_s)
print("resulting from angle variations:", np.degrees(max_psi)) 
print("Smallest distance:", min_s)
print("resulting from angle variations:",np.degrees(min_psi)) 

coi /= float(trials)
print("Centroid of estimated object positions: ", coi) 
print("Compared to object at" , lookat ) 

if graphical_output : 
    import matplotlib.pyplot as plt
    # draw eyes and object

    circle = plt.Circle(eye_l,10.0,fill=False)
    plt.gca().add_patch(circle)
    iris_l = eye_l + 10.0 *ray_l / np.sqrt(ray_l.dot(ray_l))
    circle = plt.Circle(iris_l , 3.0, fill=True, color='b') 
    plt.gca().add_patch(circle) 
    circle = plt.Circle(eye_r , 10.0, fill=False) 
    plt.gca().add_patch(circle)
    iris_r = eye_r + 10.0 *ray_r / np.sqrt(ray_r.dot(ray_r)) 
    circle = plt.Circle(iris_r , 3.0, fill=True, color='b') 
    plt.gca().add_patch(circle) 
    
    circle = plt.Circle(lookat , 5.0, fill=True, color='g') 
    plt.gca().add_patch(circle) 
    plt.scatter(x,y,marker='.' ,color='r',alpha=0.02) 
    plt.axis('scaled') 
    plt.xlim([-50,50])#plt.xlim([-50,750])
    plt.ylim([-50,750])#plt.ylim([-50,50])
    plt.margins(0.2,0.2) 
    #plt.savefig('vergence.pdf', bbox_inches='tight')
    plt.show() 





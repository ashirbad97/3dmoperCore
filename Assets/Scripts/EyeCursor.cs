using UnityEngine;
using System.Collections;

// This script shows the user's gaze by using a sphere

public class EyeCursor : MonoBehaviour
{
    public bool right = false; // Toggle to make use of the left or the right eye
    public FoveInterface foveInterface; //Comment this if u wanna use geteyerays
    //FoveInterface foveInterface = FindObjectOfType<FoveInterface>();


    // Use this for initialization
    void Start()
    {
    }

    
    
        
    
    // Latepdate ensures that the object doesn't lag behind the user's head motion
    void Update()
    {
        
        //FoveInterface.EyeRays rays = foveInterface.GetGazeRays(); //Get a set of Unity Ray objects which describe where in the scene each of the user's eyes are looking.
        FoveInterfaceBase.GazeConvergenceData gazeData = FoveInterface.GetGazeConvergence();
        transform.position = gazeData.ray.GetPoint(gazeData.distance) * 100;
        //Debug.Log("Gaze position:" + transform.position + " accuracy:" + gazeData.accuracy);
        //FoveInterface.EyeRays rays = FoveInterface.GetEyeRays(); 
        // TODO: calculate the convergence point in FoveInterface

        // Using left eye only in this script
        //RaycastHit hit; // Initialize a structure that gets information back from a raycast
        //if (right) //this is false, so the left eye ray is used. 
        //{
            //Physics.Raycast(rays.right, out hit, Mathf.Infinity); //Casts a ray from origin i.e. rays.right, in the direction "hit", of length infinity, against all colliders in the scene
        //}
        //else
        //{
            //Physics.Raycast(rays.left, out hit, Mathf.Infinity);
        //}
        //if (hit.point != Vector3.zero) // Vector3 is non-nullable; comparing to null is always false; hit.point = the impact point in the world space where the ray hit the collider
        //{
            //transform.position = hit.point;
            
        //}
        //else
        //{
            //transform.position = rays.left.GetPoint(10.0f); //Returns a point at 10 units along the left eye ray.
        //}
    }
}


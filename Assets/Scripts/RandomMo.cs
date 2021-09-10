using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomMo : MonoBehaviour
{
    public ReadXY readxy;
    int counter = 0;
	// Use this for initialization
	void Start () // This is a method
    {
        
	}
	
	// Update is called once per frame
	void Update () // This is a method
    {
		
	}
    
    void FixedUpdate() //This is a method
    {
        this.transform.position = new Vector3(readxy.posx[counter], readxy.posy[counter], readxy.posz[counter]);
        counter++;
        Debug.Log(this.transform.position);
    }
}


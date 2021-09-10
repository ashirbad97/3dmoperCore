using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour 
{
	
	Vector3 startpos = new Vector3 (0, 0, 0);
	Vector3 finalpos = new Vector3 (0, 0, 50);


	// Use this for initialization
	void Start () 
	{
		
	}
	
	// Update is called once per frame
	void Update () 
	{
		
	}

	// Update for Physics
	void FixedUpdate ()
	{
		Vector3 mypos = transform.position; // Get coordinates of the ball
		if (mypos != finalpos) // until the final position is reached
		{
			transform.position = Vector3.MoveTowards (mypos, finalpos, 1f); //move towards goal
		} 
		else 
		{
			finalpos = startpos;
			if (mypos == startpos) 
			{
				finalpos = new Vector3 (0, 0, 50);
			}
		}
		Debug.Log (mypos);
	}
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;


public class Modified_RandomMotion2 : MonoBehaviour
{
    public ReadXY readxy;
    //public float scale = 10; //These are fields
    public int counter;

    // Use this for initialization
    void Start()
    {
        counter = 0;
    }


	
	// Update is called once per frame
	void FixedUpdate ()
    {
		if (counter<1400)
        {
            this.transform.position = new Vector3(readxy.posx[counter], readxy.posy[counter],
                readxy.posz[counter]);
            Debug.Log(this.transform.position);
            counter++;
        }
        else
        {
            //Debug.Log("I am in else condition");
            SceneManager.LoadScene("Menu");
        }
	}
}

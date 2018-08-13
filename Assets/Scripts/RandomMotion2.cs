using System.Collections;
using System.Collections.Generic;
using UnityEngine; // these are namespaces
using UnityEditor;


public class RandomMotion2 : MonoBehaviour /*This means RandomMotion2 class is inheriting from MonoBehaviour class.
    MonoBehaviour is the base class which has everything reqd for Unity to run. Its a part of the UnityEngine 
    namespace. */
{
	
	public ReadXY readxy; // Call the method to read position values. This has to be public so that
    //public float scale;
    public float scale = 10; //These are fields
    public int counter;
    bool UpdateOn = true;
    //float offsetx, offsety, offsetz;

    // Use this for initialization
    void Start () //These are methods/functions. 
    {
		//counter = Random.Range(0,1400); // chooses a random number b/w 0 and 14k
        counter = 0;
		//offsetx= readxy.posx[counter]/scale; 
        //offsety = readxy.posy[counter]/scale;
        //offsetz= readxy.posz[counter]/scale;
        //offsetx = readxy.posx[counter];
        //offsety = readxy.posy[counter];
        //offsetz = readxy.posz[counter];
      
	} 
	
	// Update is called once per frame
	void Update ()
    {
        if (UpdateOn == true)
        {

            /*this.transform.position  = new Vector3(readxy.posx[counter]/scale -offsetx,readxy.posy[counter]/scale -offsety,
                readxy.posz[counter]/scale -offsetz); */
            StartCoroutine("BallPlacer");
        }
        else
        {
            StopAllCoroutines();
        }
       
            //counter = counter % 1400;
        
		//counter = counter%1400;

	}

    IEnumerator BallPlacer()
    {
        if (counter<1401)
        {
            this.transform.position = new Vector3(readxy.posx[counter], readxy.posy[counter],
                readxy.posz[counter]);
            Debug.Log(this.transform.position);
            counter++;
            yield return null;
        }
        else
        {
            EditorApplication.isPlaying = false;
            UpdateOn = false;
        }
    }
}

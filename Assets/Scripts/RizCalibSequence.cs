using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

//attached to calibsphere in Calibration scene
public class RizCalibSequence : MonoBehaviour
{
    public FoveInterface foveInterface;
    bool down = false;

    // Use this for initialization
    void Start ()
    {
        //setup
        foveInterface = FindObjectOfType<FoveInterface>();
        //do not let self collission occur! the calibration object itself should not have a collider, but if it does, disable it.
        Collider collider = this.gameObject.GetComponent<Collider>();
        if (collider)
        {
            collider.enabled = false;
        }
        GameObject target;

    }
	
	// Update is called once per frame
	void Update ()
    {
        if (Input.GetKeyDown(KeyCode.C))
        {
            //this.GetComponent<Renderer>().enabled = true;
            down = true;
        }
        if (down)
        {
            FoveInterface.EnsureEyeTrackingCalibration(); //Call the calibration routine
            SceneManager.LoadScene("Menu");
            //RaycastHit hit;
            //Ray ray = new Ray(foveInterface.transform.position, foveInterface.transform.forward);
            //if (Physics.Raycast(ray, out hit, 20.0f))
            //{
            //transform.position = hit.point;
            //}
            //else
            //{
            //transform.position = foveInterface.transform.position + foveInterface.transform.forward * 10f;
            //}
        }
        if (Input.GetKeyUp(KeyCode.C))
        {
            down = false;
            
            //this.GetComponent<Renderer>().enabled = false;
            //Fove.FoveHeadset.GetHeadset().ManualDriftCorrection3D(this.transform.localPosition); //Uncomment it while running
            //foveInterface.ManualDriftCorrection3D(this.transform.localPosition);
        }


    }
}

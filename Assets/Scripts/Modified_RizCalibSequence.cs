using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Modified_RizCalibSequence : MonoBehaviour
{
    public FoveInterface foveInterface;
    bool down = false;

    // Use this for initialization
    void Start ()
    {
        foveInterface = FindObjectOfType<FoveInterface>();
        //do not let self collission occur! the calibration object itself should not have a collider, but if it does, disable it.
        Collider collider = this.gameObject.GetComponent<Collider>();
        if (collider)
        {
            collider.enabled = false;
        }
    }
	
	// Update is called once per frame
	void Update ()
    {
        if (Input.GetKeyDown(KeyCode.C))
        {
            down = true;
        }
        if (down)
        {
            FoveInterface.EnsureEyeTrackingCalibration(); //Call the calibration routine
            SceneManager.LoadScene("Menu");
        }
    }
}

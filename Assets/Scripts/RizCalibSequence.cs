using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

//attached to calibsphere in Calibration scene
public class RizCalibSequence : MonoBehaviour
{
    public FoveInterface foveInterface;

    // Use this for initialization
    void Start ()
    {
        //setup
        foveInterface = FindObjectOfType<FoveInterface>();
    }
	
	// Update is called once per frame
	void Update ()
    {
        if (Input.GetKeyDown(KeyCode.C))
        {
            FoveInterface.EnsureEyeTrackingCalibration();
            SceneManager.LoadScene("Menu", LoadSceneMode.Additive);
            SceneManager.UnloadSceneAsync("Calibration");
        }
        if (Input.GetKeyDown(KeyCode.Space))
        {
            SceneManager.LoadScene("Menu", LoadSceneMode.Additive);
            SceneManager.UnloadSceneAsync("Calibration");
        }
    }
}

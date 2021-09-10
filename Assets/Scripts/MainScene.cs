using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainScene : MonoBehaviour {

	// Use this for initialization
	void Start () {
        SceneManager.LoadScene("Calibration", LoadSceneMode.Additive);
    }
	
	// Update is called once per frame
	void Update () {
		
	}
}

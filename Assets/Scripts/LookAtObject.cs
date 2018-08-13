using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;



public class LookAtObject : MonoBehaviour {

    Collider play_Collider;
    public GameObject foveInterfaceGo;
    public FoveInterface fi;
    public GameObject progressBar;
    
	// Use this for initialization
	void Start () {
        play_Collider = GetComponent<Collider>();
        progressBar.SetActive(true);
        fi = foveInterfaceGo.GetComponent<FoveInterface>();

    }
	
	// Update is called once per frame
	void Update ()
    {
        Scene currentScene = SceneManager.GetActiveScene();
        int buildIndex = currentScene.buildIndex;
        //if (FoveInterface.IsLookingAtCollider (this.gameObject.GetComponent<Collider>())) // raycasting: returns whether or not the user is looking at the collider
        if ((fi.Gazecast(play_Collider)) && (play_Collider.name == "StartButton"))
        {
            progressBar.SetActive(true);
           
            SceneManager.LoadScene("Stimulus");
        }
        else if ((fi.Gazecast(play_Collider)) && (play_Collider.name == "QuitButton"))
        {
            progressBar.SetActive(true);
            
            Application.Quit();
            Debug.Log("Application has been quit");
        }


    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;


// This script is attached to the Start Trial and Quit buttons
public class LookAtObject : MonoBehaviour
{

    //Collider play_Collider;
    //public GameObject foveInterfaceGo;
    //public FoveInterface fi;
    //public GameObject progressBar; Disabled for now. See backup file for details. 
    //public GameObject myCanvas;
    //Color tempColor;
    bool startbuttonActive = false;
    bool quitbuttonActive = false;

    // Use this for initialization
    void Start()
    {
        //play_Collider = GetComponent<Collider>();
        //progressBar.SetActive(true);
        //fi = foveInterfaceGo.GetComponent<FoveInterface>();
        //progressBar.SetActive(false);

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            startbuttonActive = true;
        }

        if (startbuttonActive)
        {
            //Scene currentScene = SceneManager.GetActiveScene();
            //int buildIndex = currentScene.buildIndex;
            SceneManager.LoadScene("Stimulus");
        }

        if (Input.GetKeyUp(KeyCode.Space))
        {
            startbuttonActive = false;
        }

        if (Input.GetKeyDown(KeyCode.Q))
        {
            quitbuttonActive = true;
        }
        if (quitbuttonActive)
        {
            Application.Quit();
            Debug.Log("Application has been quit");
        }

        if (Input.GetKeyUp(KeyCode.Q))
        {
            quitbuttonActive = false;
        }
    }
}
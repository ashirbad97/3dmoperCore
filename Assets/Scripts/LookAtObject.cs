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
            SceneManager.UnloadSceneAsync("Menu");
            SceneManager.LoadScene("Stimulus", LoadSceneMode.Additive);
        }
        if (Input.GetKeyDown(KeyCode.Q))
        {
            Application.Quit();
            Debug.Log("Application has been quit");
        }
    }
}
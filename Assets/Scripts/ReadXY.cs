using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEngine.SceneManagement;

public class ReadXY : MonoBehaviour
{
	
	public float[] posx;
	public float[] posy;
    public float[] posz; //New addition
    static public int trialNumber = 1; // Created a static variable for any other functions to use
	
	// Use this for initialization
	void Awake () //Awake is used to initialize variables before game starts. Called only once
    {
        
		ReadStringx();
		ReadStringy();
        ReadStringz();
	}

    void ReadStringx()
    {
        Scene currentScene = SceneManager.GetActiveScene();
        int buildIndex = currentScene.buildIndex;
        string path = null;
        switch (trialNumber)
        {
            case 1:
                //path = "xposdir3d_new"; //For the directionality expt
                path = "x_pos_fove1"; // For the 20 second experiment
                break;
            case 2:
                path = "x_pos_fove2";
                break;
            case 3:
                path = "x_pos_fove3";
                break;
            case 4:
                path = "x_pos_fove4";
                break;
            case 5:
                path = "x_pos_fove5";
                break;
            case 6:
                path = "x_pos_fove6";
                break;
        }
        //string path = "x_pos_fove";
        TextAsset positionsText = Resources.Load<TextAsset>(path);
        positionsText.text.Split(',');
        //Read the text from directly from the test.txt file
        //StreamReader reader = new StreamReader(path); 
        
        string[] numbers = positionsText.text.Split(','); //.Split('	');
        posx = new float[numbers.Length]; //1400 in this case
        for (int i = 0; i < numbers.Length; i++)
        {
            posx[i] = float.Parse(numbers[i]);
        }
 		//reader.Close();
        
        // The correct way to read file in Unity - else it wont load while building
    }
	
	 void ReadStringy()
    {
        Scene currentScene = SceneManager.GetActiveScene();
        int buildIndex = currentScene.buildIndex;
        string path = null;
        switch (trialNumber)
        {
            case 1:
                //path = "yposdir3d_new"; //For the directionality expt
                path = "y_pos_fove1"; // For the 20 second experiment
                break;
            case 2:
                path = "y_pos_fove2";
                break;
            case 3:
                path = "y_pos_fove3";
                break;
            case 4:
                path = "y_pos_fove4";
                break;
            case 5:
                path = "y_pos_fove5";
                break;
            case 6:
                path = "y_pos_fove6";
                break;
        }

        //string path = "y_pos_fove";

        //Read the text from directly from the test.txt file
        TextAsset positionsText = Resources.Load<TextAsset>(path);
        positionsText.text.Split(',');
        //Read the text from directly from the test.txt file
        //StreamReader reader = new StreamReader(path); 

        string[] numbers = positionsText.text.Split(','); //.Split('	');
        posy = new float[numbers.Length];
        for (int i = 0; i < numbers.Length; i++)
        {
            posy[i] = float.Parse(numbers[i]);
        }
 		//reader.Close();

        // The correct way to read file in Unity - else it wont load while building

    }

    void ReadStringz()
    {
        Scene currentScene = SceneManager.GetActiveScene();
        int buildIndex = currentScene.buildIndex;
        string path = null;
        switch (trialNumber)
        {
            case 1:
                //path = "zposdir3d_new"; //For the directionality expt
                path = "z_pos_fove1"; //For the 20 second experiment
                break;
            case 2:
                path = "z_pos_fove2";
                break;
            case 3:
                path = "z_pos_fove3";
                break;
            case 4:
                path = "z_pos_fove4";
                break;
            case 5:
                path = "z_pos_fove5";
                break;
            case 6:
                path = "z_pos_fove6";
                break;
        }



        //string path = "z_pos_fove";

        //Read the text from directly from the test.txt file
        TextAsset positionsText = Resources.Load<TextAsset>(path);
        positionsText.text.Split(',');
        //Read the text from directly from the test.txt file
        //StreamReader reader = new StreamReader(path); 

        string[] numbers = positionsText.text.Split(','); //.Split('	');
        posz = new float[numbers.Length];
        for (int i = 0; i < numbers.Length; i++)
        {
            posz[i] = float.Parse(numbers[i]);
        }
        //reader.Close();

        // The correct way to read file in Unity - else it wont load while building
        //AssetDatabase.ImportAsset(path);
        //TextAsset asset = Resources.Load("z_pos_fove") as TextAsset; //"z_pos_fove" for 20 sec ka expt or "z_pos_dir_3d" for the directionality
    }



}

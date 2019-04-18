using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEngine.SceneManagement;
using UnityEditor;

public class ReadXY : MonoBehaviour
{
	
	public float[] posx;
	public float[] posy;
    public float[] posz; //New addition
	
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
        switch (buildIndex)
        {
            case 1:
                //path = "Assets/Scripts/xposdir3d_new.txt"; //For the directionality expt
                path = "Assets/Scripts/x_pos_fove.txt"; // For the 20 second experiment
                break;
            case 2:
                path = "Assets/Scripts/x_pos_fove1.txt";
                break;
        } 
        //string path = "Assets/Scripts/x_pos_fove.txt";
	
        //Read the text from directly from the test.txt file
        StreamReader reader = new StreamReader(path); 
        
        string[] numbers = reader.ReadToEnd().Split(','); //.Split('	');
        posx = new float[numbers.Length]; //1400 in this case
        for (int i = 0; i < numbers.Length; i++)
        {
            posx[i] = float.Parse(numbers[i]);
        }
 		reader.Close();
        
        // The correct way to read file in Unity - else it wont load while building
        AssetDatabase.ImportAsset(path);
        TextAsset asset = Resources.Load("x_pos_fove") as TextAsset;//"x_pos_fove" for 20 sec ka expt or "x_pos_dir_3d" for the directionality
    }
	
	 void ReadStringy()
    {
        Scene currentScene = SceneManager.GetActiveScene();
        int buildIndex = currentScene.buildIndex;
        string path = null;
        switch (buildIndex)
        {
            case 1:
                //path = "Assets/Scripts/yposdir3d_new.txt"; //For the directionality expt
                path = "Assets/Scripts/y_pos_fove.txt"; // For the 20 second experiment
                break;
            case 2:
                path = "Assets/Scripts/y_pos_fove1.txt";
                break;
        }

        //string path = "Assets/Scripts/y_pos_fove.txt";
	
        //Read the text from directly from the test.txt file
        StreamReader reader = new StreamReader(path); 
        
        string[] numbers = reader.ReadToEnd().Split(','); //.Split('	');
        posy = new float[numbers.Length];
        for (int i = 0; i < numbers.Length; i++)
        {
            posy[i] = float.Parse(numbers[i]);
        }
 		reader.Close();

        // The correct way to read file in Unity - else it wont load while building
        AssetDatabase.ImportAsset(path);
        TextAsset asset = Resources.Load("y_pos_fove") as TextAsset; //"y_pos_fove" for 20 sec ka expt or "y_pos_dir_3d" for the directionality
    }

    void ReadStringz()
    {
        Scene currentScene = SceneManager.GetActiveScene();
        int buildIndex = currentScene.buildIndex;
        string path = null;
        switch (buildIndex)
        {
            case 1:
                //path = "Assets/Scripts/zposdir3d_new.txt"; //For the directionality expt
                path = "Assets/Scripts/z_pos_fove.txt"; //For the 20 second experiment
                break;
            case 2:
                path = "Assets/Scripts/z_pos_fove1.txt";
                break;
        }



        //string path = "Assets/Scripts/z_pos_fove.txt";

        //Read the text from directly from the test.txt file
        StreamReader reader = new StreamReader(path);

        string[] numbers = reader.ReadToEnd().Split(','); //.Split('	');
        posz = new float[numbers.Length];
        for (int i = 0; i < numbers.Length; i++)
        {
            posz[i] = float.Parse(numbers[i]);
        }
        reader.Close();

        // The correct way to read file in Unity - else it wont load while building
        AssetDatabase.ImportAsset(path);
        TextAsset asset = Resources.Load("z_pos_fove") as TextAsset; //"z_pos_fove" for 20 sec ka expt or "z_pos_dir_3d" for the directionality
    }



}

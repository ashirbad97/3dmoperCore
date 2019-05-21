using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using System.Text;
using System;
using UnityEngine.SceneManagement;
using Fove;


public class FOVE_EyeRecorder : MonoBehaviour
{

    /*
    * Instantiate StreamWriter and create file to write to
    This needs to be global as i am using this in a number of methods and
    i have no idea if it can be passed to Unity built in method
    */
    public static StreamWriter SW;
    //Assigned to the camera transform object
    public Transform camHead;
    //Array of Vector3 to hold LeftEye pos, RightEye Pos, Head Pos when button pressed
    public static Vector3[] startPos, endPos;
    //boolean used to see which state the game is in
    //end state means:
    //start state means:
    private static bool startPress, endPress;


    // Use this for initialization
    void Start()
    {

        //File path in string. Change as needed
        String filePath = @"E:\Rijul\UOG_Academics\Lab\VR_Unity_2017\Ball_Movement_v2_2\fove.txt";
        //Set StreamWriter path and catch exceptions if it cant be set
        SW = new StreamWriter(filePath);
        //Set the endPress to True and startPress to false
        endPress = true;
        startPress = false;
        String sceneNme = SceneManager.GetActiveScene().name;
        WriteFrameData(sceneNme);
    }

    // Update is called once per frame
    void Update()
    {
        //DebugPr(FoveInterface.GetLeftEyeVector().x + ", " + FoveInterface.GetLeftEyeVector().y + ", " + FoveInterface.GetLeftEyeVector().z);
        if (Input.GetKeyDown(KeyCode.Backslash))
        {
            if (startPress == false && endPress == true)
            {
                startPos = new Vector3[] {FoveInterface.GetLeftEyeVector(), FoveInterface.GetRightEyeVector(),
FoveInterface.GetHMDPosition(), FoveInterface.GetHMDRotation().eulerAngles};
                DebugPr("backslash Key Pressed " + "startPos Length is " + startPos.Length);
                startPress = true;
                endPress = false;
            }

        }

        if (Input.GetKeyDown(KeyCode.Slash))
        {
            if (startPress == true && endPress == false)
            {
                endPos = new Vector3[] {FoveInterface.GetLeftEyeVector(), FoveInterface.GetRightEyeVector(),
FoveInterface.GetHMDPosition(), FoveInterface.GetHMDRotation().eulerAngles};
                DebugPr("slash Key Pressed " + "endPos Length is " + endPos.Length);
                startPress = false;
                endPress = true;
            }

        }

        //this is a temporary condition to quit the app and write the data to the file
        //using this untill i figure out what i want to do
        if (Input.GetKeyDown(KeyCode.Space))
        {
            DebugPr("Space Key Pressed");
            if (startPress == false && endPress == true)
            {
                String foveData = "";
                for (int i = 0; i < startPos.Length; i++)
                {
                    foveData = foveData + startPos[i].x + "," + startPos[i].y + "," + startPos[i].z + "|";
                }
                for (int j = 0; j < endPos.Length; j++)
                {
                    foveData = foveData + endPos[j].x + "," + endPos[j].y + "," + endPos[j].z + "|";
                }
                WriteFrameData(foveData);
            }
        }

    }

    // Update is called once per frame
    void LastUpdate()
    {
        //At the end of each update set the camera position back to 0,0,0
        //Only way i have found to lock the camera position at a certain place
        camHead.position = new Vector3(0, 0, 0);
    }

    void OnApplicationQuit()
    {
        WriteFrameData("Closing :" + Time.frameCount + " -- " + Time.realtimeSinceStartup);
        //Close the StreamWriter object on apoplication quit
        SW.Close();
    }

    //This function is used to write all the data to the text file
    static void WriteFrameData(string msg)
    {
        SW.WriteLine(msg);
    }

    //Function to make debugging less of a mission
    public static void DebugPr(string msg)
    {
        Debug.Log(msg);
    }

}
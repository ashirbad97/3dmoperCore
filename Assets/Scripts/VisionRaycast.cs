using UnityEngine;
using System.Collections;

public class VisionRaycast : MonoBehaviour
{

    //public Camera playerCamera; // holds a reference to the player camera

    public GameObject cursor; // holds a reference to a cursor object to be drawn where the player's gaze points
    public PointerSelectionController cursorScript; // holds a reference to the cursor's script
    public FoveInterface foveInterface; //Comment this if u wanna use geteyerays

    void Start ()
    {
        cursorScript = cursor.GetComponent<PointerSelectionController>();
    }

    void Update ()
    {
        FoveInterface.EyeRays rays = foveInterface.GetGazeRays(); //Get a set of Unity Ray objects which describe where in the scene each of the user's eyes are looking.
        RaycastHit hit = new RaycastHit();
        //RaycastHit hit = new RaycastHit(); // this object will collect data about the collision each frame

        Physics.Raycast(rays.left, out hit, Mathf.Infinity);
        if (hit.point != Vector3.zero)
      //if (Physics.Raycast(playerCamera.transform.position, playerCamera.transform.forward, out hit)) // do the raycast, based on the camera's position and orientation, and store the hit for our reference
        {
            cursorScript.SetVisible(true); // the cursor has a script that depends on update, we want that to run regardless of whether or not it's invisible
            cursor.transform.position = hit.point; // place the cursor where the collision is happening
            if(hit.transform.gameObject.tag == "Selectable") // also, check if the thing you hit was tagged as "Selectable"
            {
                Debug.Log("I am atleast here");
                cursorScript.hittingSomething = true; // tell the cursor that it's hitting something

                if (cursorScript.state == PointerSelectionController.STATE_SELECTING) // if the cursor is in the process of selecting...
                {
                    Debug.Log("It is in state_Selecting");
                    cursorScript.state = PointerSelectionController.STATE_SELECTED; 
                }
                else if (cursorScript.state == PointerSelectionController.STATE_DESELECTING)
                {
                    Debug.Log("It is in state_Deselecting");
                    cursorScript.state = PointerSelectionController.STATE_DESELECTED;
                }
            }
            else
            {
                Debug.Log("Nothing Hitting");
                cursorScript.hittingSomething = false; // tell the cursor it's not hitting anything
                
            }
        }
        else // there wasn't any collision
        {
            cursor.transform.position = rays.left.GetPoint(10.0f);//Returns a point at 10 units along the left eye ray.
            cursorScript.SetVisible(false); // deactivate the cursor if it was active
            cursorScript.hittingSomething = false; // tell the cursor it's not hitting anything
        }

    }
}

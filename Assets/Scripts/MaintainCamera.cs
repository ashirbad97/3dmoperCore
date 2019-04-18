using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MaintainCamera : MonoBehaviour {

    public GameObject FoveRigPrefab;
    public static Camera cam;
    

    // Use this for initialization
    private void Awake()
    {
        // Check if cam exists
        // If not, ensure it does not get destroyed
        // Otherwise, destroy cam
        if (cam == null)
        {
            DontDestroyOnLoad(gameObject);
            cam = MaintainCamera.cam;
        }
        else if (cam != this)
        {
            Destroy(gameObject);

        }

        // Instantiate the Fove Rig 2 prefab
        Instantiate(FoveRigPrefab, transform, false);

    }
}

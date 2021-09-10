using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DelayAttach : MonoBehaviour
{

    // Use this for initialization
    void Start()
    {
        StartCoroutine(AttachScripts());
    }

    // Update is called once per frame
    void Update()
    {

    }


    IEnumerator AttachScripts()
    {
        yield return new WaitForSeconds(5);
        FOVERecorder2 foveRecorder = gameObject.AddComponent<FOVERecorder2>();
        Modified_RandomMotion2 randomMotion = gameObject.AddComponent<Modified_RandomMotion2>();
        randomMotion.readxy = GetComponent<ReadXY>();
        
    }
}
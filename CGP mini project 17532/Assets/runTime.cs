using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class runTime : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        GetComponent<Renderer>().sharedMaterial.SetFloat("_RunTime", Time.time);
	}
}

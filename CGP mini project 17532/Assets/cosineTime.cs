using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cosineTime : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        Debug.Log(Mathf.Cos(Time.time));
	}
}

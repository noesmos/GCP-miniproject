using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class recalculateNormals : MonoBehaviour {

	// Use this for initialization
	void Start () {

    }
	
	// Update is called once per frame
	void Update () {
		        Mesh mesh = GetComponent<MeshFilter>().mesh;
        mesh.RecalculateNormals();
	}
}

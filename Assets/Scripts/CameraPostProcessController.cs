using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CameraPostProcessController : MonoBehaviour
{
    public Material mat;
    
    private void Update() {
        Vector3 mousePos = Input.mousePosition;
        mat.SetVector("_MousePos", new Vector2(mousePos.x / Screen.width, mousePos.y / Screen.height));
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dst) {
        Graphics.Blit(src, dst, mat);
    }
}

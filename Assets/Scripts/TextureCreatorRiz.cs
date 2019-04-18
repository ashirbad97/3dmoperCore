using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextureCreatorRiz : MonoBehaviour {
    public int resolution = 256; //How many pixels do u want to quad to have? Preferably a power of 2 for textures
    private Texture2D texture;

    //public Gradient coloring; // In case u want to change colors of the 1/f noise. 

    private void Awake() // Or u can use Awake/OnEnable also; Awake is not called again when recompiled. 
    {
        //Create the texture when our component awakens
        // As we won't use transparency, the texture's format is RGB.
        texture = new Texture2D(resolution, resolution, TextureFormat.RGB24, true);// 8 bits each for R,G,B; "true" is for mipmaps
        // Mipmaps are downsampled versions of the base texture, each at half the resolution of the previous level. 
        // When used, the GPU decides which level to render based on which best matches the output resolution.
        // When a smaller area is covered, a smaller mipmap is chosen.
        texture.name = "Procedural Texture"; // Some descriptive name
        GetComponent<MeshRenderer>().material.mainTexture = texture; // grab the MeshRenderer component of the game object. 
        // Because we're only using it with our quad object, it should exist so we directly assign the texture to its material.
        FillTexture(); // After writing the method FillTexture below
    }

    public float frequency = 1f;

    [Range(1, 8)]
    public int octaves = 1; //Combine samples at diff freq to get 1/f noise or Pink Noise

    [Range(1f, 4f)]
    public float lacunarity = 2f; // The factor by which the frequency changes. Generally, frequency is exactly doubled each octave

    [Range(0f, 1f)]
    public float persistence = 0.5f; //Generally, amplitude need to be exactly halved. But u can change this and lacunarity to see other results

    [Range(1, 3)]
    public int dimensions = 3; //we can configure which noise value it should use. To limit the value we can set it to via the inspector, 
    // give it a range from 1 to 3.
   

    public NoiseMethodType type; //Enumeration from RizNoise. so we can use the inspector to switch between Value noise and Perlin noise.

    private void FillTexture()
    {
        if (texture.width != resolution)
        {
            texture.Resize(resolution, resolution);
        }

        Vector3 point00 = new Vector3(-0.5f, -0.5f);
        Vector3 point10 = new Vector3(0.5f, -0.5f);
        Vector3 point01 = new Vector3(-0.5f, 0.5f);
        Vector3 point11 = new Vector3(0.5f, 0.5f);

        RizNoiseMethod method = RizNoise.noiseMethods[(int)type][dimensions - 1];
        //RizNoiseMethod method = RizNoise.valueMethods[dimensions - 1]; //we can let TextureCreatorRiz.FillTexture select the desired method 
        //from the value methods array, using "dimensions minus one" as an index.Then we can call this method to get our noise value in texture.SetPixel
        float stepSize = 1f / resolution; // For gradient of colors only
        //Random.InitState(42);
        //Random.seed = 42; // This is deprecated now. Use InitState
        for (int y = 0; y<resolution; y++)
        {
            Vector3 point0 = Vector3.Lerp(point00, point01, (y + 0.5f) * stepSize);
            Vector3 point1 = Vector3.Lerp(point10, point11, (y + 0.5f) * stepSize);
            for (int x = 0; x<resolution; x++)
            {
                Vector3 point = Vector3.Lerp(point0, point1, (x + 0.5f) * stepSize);
                float sample = RizNoise.Sum(method, point, frequency, octaves, lacunarity, persistence); //can pass its noise method to "Sum" instead of calling it directly as below.
                //float sample = method(point, frequency);
                if (type != NoiseMethodType.Value)
                {
                    sample = sample * 0.5f + 0.5f;
                }
                //texture.SetPixel(x, y, coloring.Evaluate(sample)); Toggle this and gradient and top if u want other gradient of colors
                texture.SetPixel(x, y, Color.white * sample);
                //texture.SetPixel(x, y, Color.white * method(point, frequency));
                //texture.SetPixel(x, y, Color.white * RizNoise.Value2D(point, frequency)); // Use custom noise library instead of Random Noise
                //texture.SetPixel(x, y, Color.white * Random.value); // If using Random Noise pattern. Use the RandomInitState(42). 
                //texture.SetPixel(x, y, Color.green); // Choose whichever color u want
                //texture.SetPixel(x, y, new Color(x * stepSize, y * stepSize, 0f)); // For gradient of colors only. 
            }
        }
        texture.Apply(); // To apply the changes created in the for loop
    }
    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}

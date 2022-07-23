uniform float time;
uniform float randomSeed;
uniform float objectOpacity;
uniform float noisePower;
uniform float pixelRatio;
uniform vec2 resolution;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;

varying vec3 vPosition;

#include utils/noise;

float lines(vec2 uv, float offset, float numberOfLines) {
  return smoothstep(
    0.0,
    0.5 + offset * 0.5,
    abs(0.55 * (sin(uv.x * 12.0) + offset * 2.0))
  );
}

vec3 normalizeRGBColor(vec3 color) {
  return color / 255.0;
}

mat2 getRotationMatrix(float angle) {
  return mat2(
    cos(angle), -sin(angle),
    sin(angle), cos(angle)
  );
}

float rand(vec2 p) {
    vec2 k1 = vec2(
        23.14069263277926, // e^pi (Gelfond's constant)
        2.665144142690225 // 2^sqrt(2) (Gelfond–Schneider constant)
    );
    return fract(
        cos(dot(p, k1)) * 12345.6789
    );
}

void main() {
  float shaderZoom = 0.0;

  if (resolution.x > 700.0) shaderZoom = 0.25;
  else shaderZoom = 0.45;

  // vec3 color1 = vec3(0.0, 0.0, 0.0);
  // vec3 color2 = vec3(255.0, 230.0, 237.0);
  // LIGHTGREEN-ish
  // vec3 color3 = vec3(230.0, 255.0, 233.0);
  // GREEN-ish
  // vec3 color3 = vec3(125.0, 179.0, 132.0);
  // DARK-GREEN-ish
  // vec3 color3 = vec3(89.0, 128.0, 94.0);
  // NOT-SO-DARK-GREEN-ish
  // vec3 color3 = vec3(51.0, 128.0, 61.0);
  // DESATURATED-GREEN-ish
  // vec3 color3 = vec3(143.0, 204.0, 151.0);
  // BLACK-ish
  // vec3 color3 = vec3(64.0, 57.0, 59.0);
  // PINK-BLACK-ish
  // vec3 color3 = vec3(128.0, 115.0, 118.0);
  // LIGHTBLUE+GRAY-ish
  // vec3 color3 = vec3(152.0, 172.0, 179.0);

  vec3 _color1 = normalizeRGBColor(color1);
  vec3 _color2 = normalizeRGBColor(color2);
  vec3 _color3 = normalizeRGBColor(color3);

  float noise = snoise(vPosition + time * 0.175 + randomSeed * 100.0) * (noisePower * 0.55);

  vec2 baseUv = getRotationMatrix(noise + -1.0) * vPosition.xy * shaderZoom;

  float firstPattern = lines(baseUv, 0.5, 10.0);
  float secondPattern = lines(baseUv, 0.05, 15.0);

  vec3 firstColor = mix(_color3, _color2, firstPattern);
  vec3 resColor = mix(firstColor, _color1, secondPattern);

  float grainStrength = 0.075;
  if (pixelRatio > 2.0) grainStrength = 0.135;

  vec2 uvNoise = vPosition.xy;
  uvNoise.y *= rand(vec2(uvNoise.y, randomSeed));
  vec3 grain = vec3(rand(uvNoise) * grainStrength);

  resColor += grain;

  gl_FragColor = vec4(resColor, 1.0) * objectOpacity;
}

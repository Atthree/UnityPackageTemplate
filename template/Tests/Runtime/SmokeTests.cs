using System.Collections;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.TestTools;

namespace __NAMESPACE__.Tests
{
    /// <summary>
    /// Örnek PlayMode testi. Kendi testlerini bu dosyanın yanına ekle.
    /// Çalıştırmak için projenin Packages/manifest.json dosyasına şunu ekle:
    ///   "testables": [ "__PACKAGE_ID__" ]
    /// Sonra Window > General > Test Runner > PlayMode.
    /// </summary>
    public class SmokeTests
    {
        [UnityTest]
        public IEnumerator PhysicsRuns()
        {
            var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
            go.AddComponent<Rigidbody>();
            float startY = go.transform.position.y;

            yield return new WaitForSeconds(0.5f);

            Assert.Less(go.transform.position.y, startY, "Cisim yerçekimiyle düşmeliydi.");
            Object.Destroy(go);
        }
    }
}

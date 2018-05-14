// iobaixas@gmail.com, dperezrada@gmail.com

var Consorcio = artifacts.require("./Consorcio.sol");

contract('Consorcio', function(accounts) {
  var pepe = accounts[0];
  var pipo = accounts[1];

  describe("dado que el contrato ya fue instalado", function() {
    var consorcio;

    beforeEach(function() {
      return Consorcio.new({ from: pepe }).then(function(instance) {
        consorcio = instance;
      });
    });

    describe("soySocio", function() {
      it("agrega al creador como primer socio", function() {
        consorcio.soySocio.call({ from: pepe }).then(function(resultado) {
          assert.equal(resultado, true, "pepe no es socio!");
        });
      });
    });

    describe("dada una propuesta activa que agrega a un socio", function () {
      beforeEach(function() {
        // crear nueva propuesta
        return consorcio.proponer('nuevo socio', pipo, { from: pepe, gas: 100000 });
      });

      describe("votar", function () {
        it("agrega al nuevo socio a la lista de socios si el voto es positivo", function() {
          return consorcio.votar(true).then(function() {
            return consorcio.soySocio.call({ from: pipo });
          }).then(function(resultado) {
            assert.equal(resultado, true, "pipo no es socio");
          });
        })

        it("no agrega al nuevo socio a la lista de socios si el voto es negativo", function() {
          return consorcio.votar(false).then(function() {
            return consorcio.soySocio.call({ from: pipo });
          }).then(function(resultado) {
            assert.equal(resultado, false, "pipo es socio");
          });
        })
      })
    })
  })
});

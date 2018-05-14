pragma solidity ^0.4.18;

contract Consorcio {
  event PropuestaTerminada(string titulo, bool resultado);

  struct Propuesta {
    address creador;
    string titulo;
    address nuevoSocio;
    mapping (address => bool) votos;
    uint positivos;
    uint negativos;
  }

  mapping (address => bool) socios;
  uint numeroSocios;
  Propuesta actual;

  modifier soloSocios() {
    require(socios[msg.sender]);
    _;
  }

  function Consorcio() public {
    socios[msg.sender] = true;
    numeroSocios = 1;
  }

  function soySocio() public constant returns (bool) {
    return socios[msg.sender];
  }

  function proponer(string _titulo, address _nuevoSocio) public soloSocios {
    require(actual.creador == 0x0);

    actual.creador = msg.sender;
    actual.titulo = _titulo;
    actual.nuevoSocio = _nuevoSocio;
  }

  function votar(bool _positivo) public soloSocios {
    require(!actual.votos[msg.sender]);

    actual.votos[msg.sender] = true;
    if(_positivo) actual.positivos += 1;
    else actual.negativos += 1;

    revisarTermino();
  }

  function revisarTermino() private {
    if(actual.positivos + actual.negativos == numeroSocios) {
      bool positivo = actual.positivos > actual.negativos;

      PropuestaTerminada(actual.titulo, positivo);

      if(positivo) {
        if(actual.nuevoSocio != 0x0) {
          socios[actual.nuevoSocio] = true;
          numeroSocios += 1;
        }
      }

      delete actual;
    }
  }
}

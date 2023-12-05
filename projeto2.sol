// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Votacao {


    uint public counter = 0;
    
    struct eleicao{
        string objetivo;
        string[] opcoes;
        uint comeco;
        uint duracao;
    }

    //Vetor com os objetos eleicao
    mapping(uint => eleicao) private _eleicoes;
    //Vetor com a contagem de cada eleicao
    mapping(uint => mapping(uint => uint)) private contagem;

    //Controla se aquele endereco ja votou
    mapping(uint => mapping(address => bool)) public jaVotou;


    function createEleicao(
        string memory objetivo_,
        string[] memory opcoes_,
        uint comeco_,
        uint duracao_
    ) external {
        require(opcoes_.length >= 2, "Por favor indique pelo menos 2 opcoes.");
        require(comeco_ > block.timestamp, "Tempo de comeco invalido.");
        _eleicoes[counter] = eleicao(objetivo_, opcoes_, comeco_, duracao_);
        counter++;
    }

    function fazVoto(uint indexEleicao_, uint indexOpcao_) external {
        require(jaVotou[indexEleicao_][msg.sender] != true, "Voce ja votou nessa eleicao.");
        require(_eleicoes[indexEleicao_].comeco <= block.timestamp, "Votacao nao disponivel." );
        require(_eleicoes[indexEleicao_].comeco + _eleicoes[indexEleicao_].duracao > block.timestamp, "Votacao ja encerrada." );
        
        contagem[indexEleicao_][indexOpcao_]++;
        

        jaVotou[indexEleicao_][msg.sender] = true;
    }


    function getEleicaoByIndex(uint index_) external view returns (eleicao memory instEleicao) {
        instEleicao = _eleicoes[index_];
    }

    function resultado(uint indexEleicao_) external view returns (uint[] memory) {
    eleicao memory instEleicao = _eleicoes[indexEleicao_];
    uint len = instEleicao.opcoes.length;
    uint[] memory result = new uint[](len);
    for (uint i = 0; i < len; i++) {
        result[i] = contagem[indexEleicao_][i];
    }

    return result;
    }


    function vencedor(uint indexEleicao_) external view returns (bool[] memory) {
    eleicao memory instEleicao = _eleicoes[indexEleicao_];
    uint len = instEleicao.opcoes.length;
    uint[] memory result = new uint[](len);
    uint max;
    for (uint i = 0; i < len; i++) {
        result[i] = contagem[indexEleicao_][i];
        if (result[i] > max) {
        max = result[i];
        }
    }
    bool[] memory winner = new bool[](len);
    for (uint i = 0; i < len; i++) {
        if (result[i] == max) {
        winner[i] = true;
        }
    }
    return winner;
    }

    function tempo() external view  returns(uint time){
        time = block.timestamp;
    }





}
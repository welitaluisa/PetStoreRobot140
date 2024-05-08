*** Settings ***
# Biblioteca e Configuração 
Library    RequestsLibrary
Library    ../.venv/Lib/site-packages/robot/libraries/Telnet.py

*** Variables ***
# Objetos, Atributos e Variables 
${url}    https://petstore.swagger.io/v2/pet

${id}      93894949501              # $ Sinaliza uma variavel simples
${name}    Snoopy
&{category}    id=1    name=dog     # &  lista com campos determinados. Ex: id e name - seria {}
@{photoUrls}                        # @  lista com vários registros - seria []
&{tag}    id=1    name=vacinado
@{tags}    ${tag}                  # Lista de outra lista 
${status}

*** Test Cases ***
# Descritivo de Negócio + Passos de Automação 

Post Pet
    # Montar a mensagem / body
    ${body}    Create Dictionary    id=${id}    category=${category}    name=${name}    
    ...                            photoUrls=${photoUrls}    tags=${tags}    status=${status}    
    
    # Executar 
    ${response}    POST    url=${url}    json=${body}

    # Validar
    ${response_body}    Set Variable      ${response.json()}
    Log To Console    ${response_body}  # imprimir o retorno da API no terminal / console
    
    Status Should Be    200
    Should Be Equal    ${response_body}[id]             ${{int($id)}}
    Should Be Equal    ${response_body}[name]           ${name} 
    Should Be Equal    ${response_body}[tags][0][id]    ${{int(${tag}[id])}}
    Should Be Equal    ${response_body}[tags][0][name]  ${tag}[name]
    Should Be Equal    ${response_body}[status]         ${status}    
*** Keywords ***
# Descritivo de Negócio ( Se estruturar separadamente)
# DSL = Domain Specific Language 
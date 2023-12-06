# MC853 - Projeto TV Box - Provisioning

# Motivação
O projeto tem como objetivo criar a infraestrutura necessária para facilitar o processo de desenvolvimento,
teste e configuração de TV Boxes. Para isso, utilizamos duas ferramentas - Ansible para a configuração das TV Boxes,
e Vagrant para criar máquinas virtuais que permitam testar tanto o que é feito com Ansible, quanto as aplicações que
serão instaladas ou desenvolvidas para as TV Boxes.

Além disso, como exemplo do processo de configuração e possível aplicação de uma ou mais TV Boxes, um cluster usando
o orquestrador de tarefas Nomad foi criado.


# Hashicorp Vagrant

O [HashiCorp Vagrant](https://www.vagrantup.com/) é uma ferramenta de código aberto que automatiza a criação e
gerenciamento de ambientes de desenvolvimento virtualizados. Ele simplifica a configuração e provisionamento de
máquinas virtuais, permitindo aos desenvolvedores criar ambientes consistentes em diferentes plataformas. 
O Vagrant facilita a reprodução de configurações de desenvolvimento em vários sistemas operacionais,
melhorando a consistência e a colaboração entre equipes de desenvolvimento.

## Quickstart

Na raíz do repositório existe um arquivo chamado _Vagrantfile_. Nele estão definidas as configurações de uma máquina
virtual que utiliza uma imagem de Armbian, muito parecida com o que instalamos nas TV Boxes. 
Para criar a máquina virtual, basta rodar o comando `vagrant up`. 
Por padrão, a senha e usuário da VM são a mesma: `vagrant` e `vagrant`. Para acessar a VM por ssh, use `vagrant ssh`. 

Existem muitas configurações que podem ser feitas para utilizar a VM através do Vagrant; entre elas, configurar
um endereço de IP público que pode ser usada para acessar remotamente a VM (algo que usaremos no Ansible) e, também,
_port forwarding_ para acessar portas da VM na sua máquina local, facilitando o desenvolvimento ou teste de aplicações
que estejam rodando na VM criada pelo Vagrant.

# Ansible

O Ansible é uma ferramenta de automação de TI de código aberto que simplifica o gerenciamento de configurações,
a automação de tarefas e a orquestração de aplicativos. Ele utiliza uma abordagem baseada em YAML para definir as
configurações desejadas e é projetado para ser simples, flexível e eficiente, permitindo automatizar processos em
sistemas heterogêneos. O Ansible é frequentemente usado para provisionar, configurar e coordenar servidores e serviços
em ambientes de nuvem e locais.

Em resumo, o Ansible permite definir configurações que faríamos manualmente, como instalar aplicações, copiar arquivos
de configuração para certas pastas ou criar serviços de sistema. A vantagem é ter essas definições de forma reproduzível
e, caso usado corretamente, garantindo idempotência nas operações. Isto é feito via uma conexão SSH com a máquina que
precisa ser configurada, ou seja, não existe a necessidade de ter o Ansible instalado na máquina alvo.


## Quickstart
O exemplo utilizado aqui faz a configuração de algumas ferramentas: Docker, Nomad e Consul.

Recomendo a leitura dessa parte da documentação: 
[Ansible Role Directory Structure](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#role-directory-structure)
para entender a estrutura de pastas utilizada.

De forma geral, para testar o que já está definido, é necessário alterar somente um arquivo: [tvbox1.yml](ansible/host_vars/tvbox1.yml).
Altere os valores para refletir o IP, usuário e senha da sua TV Box. Faça o mesmo para a sua VM, caso ela exista.

Toda configuração do Ansible possui um _playbook_; lá são definidas as tarefas (ou _roles_) que serão executadas e,
também, em quais _hosts_. O [playbook](ansible/playbook.yml) na raíz da pasta `ansible` demonstra isso:

```
- name: TV Box Configuration
  hosts:
    - virtual_machines
    - physical_machines
  roles:
    - common
    - docker
    - consul
    - nomad
```

Isso significa que os _roles_ `common`, `docker`, `consul` e `nomad` serão executados nos _hosts_
`virtual_machines` e `physical_machines`. Estes _hosts_ estão definidos no [inventory.ini](ansible/inventory.ini).

Para realizar a configuração, estando na pasta `ansible`, rode o comando `ansible-playbook -i inventory.ini playbook.yml`.

Este é apenas um exemplo; é possível realizar qualquer tipo de configuração, em qualquer número de máquinas, que seria
feita manualmente através do Ansible.

# Exemplo: Cluster utilizando Nomad e Consul

A configuração de um orquestrador de tarefas pode ser complexa ou, no mínimo, tediosa. Por isso, é um bom exemplo de
como usar ferramentas que permitam a configuração e teste em ambientes controlados; no nosso caso,
a combinação do Vagrant e Ansible.

Além disso, é um exemplo de uma possível aplicação para um conjunto de TV Boxes: utilizar esse poder de processamento
para fins educativos - testes de aplicações distribuídas, treinamento de modelos em Machine Learning e LLMs,
implementação de uma arquitetura de microserviços ou, até mesmo, para aprender sobre a configuração do cluster em si.

## [Hashicorp Nomad](https://www.nomadproject.io/)

- Nomad é um agendador flexível e um orquestrador de carga de trabalho que permite a uma organização implantar 
e gerenciar facilmente qualquer aplicativo containerizado ou legado usando um único fluxo de trabalho unificado. 
- O Nomad pode executar uma variedade de cargas de trabalho, incluindo aplicativos Docker, não containerizados,
microsserviços e processos em lote.

### Casos de uso principais


- **Orquestração de contêineres Docker**
- **Implantação de aplicativos legados**: permite a implantação de aplicativos nativos usando seus [drivers de tarefas](https://developer.hashicorp.com/nomad/docs/drivers), que incluem JARs Java e comandos de sistema operacional.
- **Microsserviços**: Microsserviço e Arquiteturas Orientadas a Serviços (SOA) são um paradigma de design em que muitos serviços com escopo limitado, encapsulamento rigoroso e comunicação orientada por API formam a base de um sistema/solução inteiro.
- **Cargas de trabalho de processamento em lote**: O Nomad oferece a capacidade de executar trabalhos de curta duração que realizam algum tipo de processamento e são automaticamente excluídos quando o processamento/execução em lote termina.

## [Hashicorp Consul](https://www.consul.io/)

- O HashiCorp Consul é um software de código aberto projetado para fornecer descoberta de serviços, segmentação de rede e automação de rede para ambientes de computação em nuvem e infraestrutura moderna. 

### Casos de Uso
- **Descoberta de Serviços**: Consul permite que os aplicativos descubram automaticamente os serviços disponíveis em uma rede. Isso é especialmente útil em ambientes dinâmicos, como contêineres e orquestradores de contêineres, onde os serviços podem ser implantados e desligados rapidamente.
-  **Monitoramento de Saúde de Serviços**: O Consul verifica continuamente a saúde dos serviços e pode rotear automaticamente o tráfego para serviços saudáveis, garantindo uma alta disponibilidade.
- **Integração com Orquestradores de Contêineres**: O Consul é frequentemente usado em conjunto com orquestradores de contêineres, como o Kubernetes, para melhorar a descoberta de serviços e a segmentação de rede em ambientes de contêineres.

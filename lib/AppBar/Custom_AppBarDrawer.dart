import 'package:edywasacliente/Cores/cores.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Função para o AppBar customizado
PreferredSizeWidget customAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: azul, // Cor do cabeçalho
    elevation: 0, // Remove a sombra
    toolbarHeight: 110, // Altura do AppBar
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.white,
          iconSize: 40, // Tamanho do ícone de menu
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Abre o Drawer
          },
        );
      },
    ),
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Centraliza a coluna
      children: [
        ClipRRect(
          borderRadius:
              BorderRadius.circular(15), // Arredonda as bordas da logo
          child: Image.asset(
            'assets/logo2.png', // Caminho para a logo
            width: 115, // Largura da logo
            height: 45, // Altura da logo
            fit: BoxFit
                .cover, // Garante que a imagem ocupe o espaço adequadamente
          ),
        ),
        const SizedBox(height: 5), // Espaço entre a imagem e o texto
        const Text(
          'Cliente', // Texto abaixo da imagem
          style: TextStyle(
            color: Colors.white, // Cor do texto
            fontSize: 16, // Tamanho da fonte
          ),
        ),
      ],
    ),
    actions: [
      InkWell(
        onTap: () {
          _changeCity(context); // Abre o filtro para trocar a cidade
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      'Tupã', // Cidade atual (substituir pela lógica dinâmica)
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,             
                      ),
          
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.location_on,
                        color: Colors.white),
                         // Ícone de localização
                  ],
                ),
            
                SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Onde estou', // Texto "Onde estou"
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 18)//Espaçmento da linha onde estou!
                  ],
                ),
              ],
            ),
            SizedBox(width: 30), // Espaço à direita do ícone
          ],
        ),
      ),
    ],
  );
}

// Função para o Drawer customizado
Drawer customDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: azul, // Cor do cabeçalho do Drawer
          ),
          child: const Row(
            children: [
              // Ícone à esquerda
              Icon(
                Icons.account_circle, // Substitua pelo ícone desejado
                color: Colors.white,
                size: 100, // Tamanho do ícone
              ),
              SizedBox(width: 10), // Espaço entre o ícone e o texto/logo
              // Texto ou logo à direita do ícone
              Text(
                'Cliente',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        // Itens com ícones e ações específicas
        _buildListTileWithIcon(
          context,
          icon: Icons.people,
          title: 'Lista de Profissionais',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/listaProfissionais');
          },
        ),
        _buildListTileWithIcon(
          context,
          icon: Icons.list_alt,
          title: 'Minhas Solicitações',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/minhasSolicitacoes');
          },
        ),
        _buildListTileWithIcon(
          context,
          icon: Icons.edit,
          title: 'Editar Perfil',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/editarPerfil');
          },
        ),
        _buildListTileWithIcon(
          context,
          icon: Icons.star_rate,
          title: 'Avaliar Profissional',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/avaliarProfissional');
          },
        ),
        _buildListTileWithIcon(
          context,
          icon: Icons.favorite,
          title: 'Meus Favoritos',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/meusFavoritos');
          },
        ),
        _buildListTileWithIcon(
          context,
          icon: Icons.share,
          title: 'Siga-nos',
          onTap: () {
            Navigator.pop(context);
            // Exemplo de abrir URL externa
            debugPrint('Abrindo redes sociais...');
          },
        ),
        _buildListTileWithIcon(
          context,
          icon: Icons.report_problem,
          title: 'Denuncie',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/denuncie');
          },
        ),
        _buildListTileWithIcon(
          context,
          icon: Icons.support_agent,
          title: 'Suporte Starcase',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/suporte');
          },
        ),
        _buildListTileWithIcon(
          context,
          icon: Icons.desktop_windows,
          title: 'Experimentar a versão desktop',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/versaoDesktop');
          },
        ),
        const Divider(), // Linha separadora
        // Botão de Sair
        _buildListTileWithIcon(
          context,
          icon: Icons.logout,
          title: 'Sair',
          onTap: () async {
            // Deslogar do Firebase
            await FirebaseAuth.instance.signOut();
            Navigator.pop(context);
            debugPrint('Usuário saiu.');
          },
        ),
      ],
    ),
  );
}

// Função para criar ListTile com ícones
Widget _buildListTileWithIcon(BuildContext context,
    {required IconData icon,
    required String title,
    required VoidCallback onTap}) {
  return ListTile(
    leading: Icon(icon, color: azul), // Ícone na cor desejada
    title: Text(
      title,
      style: const TextStyle(fontSize: 16),
    ),
    onTap: onTap,
  );
}

// Função para criar itens com ações específicas
Widget _buildCompactListTile(String title, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        vertical: 2), // Espaçamento reduzido entre os itens
    child: ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16), // Tamanho ajustado para o texto
      ),
      onTap: onTap, // Chama a ação passada como parâmetro
      dense: true, // Torna o ListTile mais compacto
      visualDensity:
          const VisualDensity(vertical: -4), // Reduz ainda mais o espaçamento
      contentPadding:
          EdgeInsets.zero, // Remover espaço extra ao redor do ListTile
    ),
  );
}

// Função para criar ListTile para o botão "Sair" com setinha de recolher menu
Widget _buildListTileWithExit(BuildContext context,
    {required IconData icon,
    required String title,
    required VoidCallback onTap}) {
  return ListTile(
    leading: Icon(icon, color: azul), // Ícone na cor desejada
    title: Text(
      title,
      style: const TextStyle(fontSize: 16),
    ),
    trailing: const Icon(
      Icons.arrow_back_ios, // Setinha indicando que o menu pode ser recolhido
      color: Colors.grey, // Cor da setinha
      size: 16, // Tamanho da setinha
    ),
    onTap: onTap,
  );
}

Future<String> _getCurrentCity() async {
  // Simula a obtenção da cidade atual
  await Future.delayed(const Duration(seconds: 1)); // Simulação de delay
  return "São Paulo"; // Retorne a cidade real aqui
}

void _changeCity(BuildContext context) {
  // Lista de cidades para exemplo
  List<String> cities = [
    "São Paulo",
    "Rio de Janeiro",
    "Curitiba",
    "Belo Horizonte"
  ];
  String selectedCity = "São Paulo"; // Cidade inicial

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Selecione a Cidade"),
        content: DropdownButton<String>(
          value: selectedCity,
          items: cities.map((String city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(city),
            );
          }).toList(),
          onChanged: (String? newValue) {
            selectedCity = newValue!;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo sem alterar
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              // Atualiza a cidade aqui
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cidade alterada para $selectedCity')),
              );
            },
            child: const Text("Confirmar"),
          ),
        ],
      );
    },
  );
}

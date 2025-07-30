void main() {
  final now = DateTime.now();
  int informado = now.month;
  int atual = 8;

  if(atual > informado){
    print('$atual é maior que $informado');
  }else if(atual < informado){
    print('$atual é menor que $informado');
  }else{
    print('$atual é igual a $informado');
  }
}  
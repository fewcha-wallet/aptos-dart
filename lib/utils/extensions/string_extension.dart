extension StringExtension on String{
  bool stringToBool(){
    if(isEmpty) return false;
    if(toLowerCase()=='false') return false;
    return true;
  }
}
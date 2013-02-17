/*-----------------------------------------------------------------------------*/
void RxError(int ErrCode, char Cmd, int Len, int ChkSum)
{
  RS232Port.clear();
  RxErrorDispTime = 100;
  switch (ErrCode)
  {
    case 1: // Timeout
      RxErrorText= "TMO - No RX";
      RxErrorExpected = ' ';
      RxErrorFound = ' ';
    break;
    
    case 2: // no header found
      RxErrorText= "No Header";
      RxErrorExpected = '@';
      RxErrorFound =(char)(RxBuff[0]);
    break;
    
    case 3: // the command received doesn't match what expected
      RxErrorText= "Wrong CMD";
      RxErrorExpected = Cmd;
      RxErrorFound = (char)(RxBuff[2]);
    break;
      
    case 4:
      RxErrorText= "Wrong LEN";
      RxErrorExpected = (char)(Len);
      RxErrorFound = (char)(RxBuff[3]-1);
    break;
  
    case 5:
      RxErrorText= "ChkSum err";
      RxErrorExpected = (char)(+RxBuff[i]);
      RxErrorFound = (char)(ChkSum);
    break;
  
    default:
      RxErrorText= "-RX OK-";
      RxErrorExpected = ' ';
      RxErrorFound =  ' ';
    break;
  
  }
  
  Err++;
} 

/*-----------------------------------------------------------------------------*/
void ArduRxError(int ErrCode, char Cmd, int Len, int ChkSum)
{
  ArduinoPort.clear();
  RxErrorDispTime = 100;
  if(!ArduinoFlag)
  {
      ArduRxErrorText= "-NO Joy-";
  }
  else
  {
    switch (ErrCode)
    {
      case 1: // Timeout
        ArduRxErrorText= "TMO - No RX";
        RxErrorExpected = ' ';
        RxErrorFound = ' ';
      break;
      
      case 2: // no header found
        ArduRxErrorText= "No Header";
        RxErrorExpected = '@';
        RxErrorFound =(char)(RxBuff[0]);
      break;
      
      case 3: // the command received doesn't match what expected
        ArduRxErrorText= "Wrong CMD";
        RxErrorExpected = Cmd;
        RxErrorFound = (char)(RxBuff[2]);
      break;
        
      case 4:
        ArduRxErrorText= "Wrong LEN";
        RxErrorExpected = (char)(Len);
        RxErrorFound = (char)(RxBuff[3]-1);
      break;
  
      case 5:
        ArduRxErrorText= "ChkSum err";
        RxErrorExpected = (char)(+RxBuff[i]);
        RxErrorFound = (char)(ChkSum);
      break;
  
      default:
        ArduRxErrorText= "-Joy OK-";
        RxErrorExpected = ' ';
        RxErrorFound =  ' ';
      break;
    
    }
  }
  
  Err++;
} 

/*-----------------------------------------------------------------------------*/
boolean RxData(char Cmd,int Len)
{
  int ChkSum = 0;
  int StartTime;
  int Timeout=1000; //ms
  
  if (RS232Flag)  // RS232 initialized
  {
      StartTime=millis();
      while (RS232Port.available() <= (Len+HeadLen)) // wait data
      {
        if((millis()-StartTime) > Timeout)
        {
          RxError(1, Cmd, Len, ChkSum);
          return false;
        }
      }
      
      for (i=0; i < Len+HeadLen+1; i++)  // loop for all data expected and only for that
      {
        RxBuff[i] = (RS232Port.read());
        /*
        print(i);
        print("  ");
        println(RxBuff[i]);
        */
      }
      
      if (RxBuff[0] != '@')
      {
        RxError(2, Cmd, Len, ChkSum);
        return false;
      }
      else if (RxBuff[2] != Cmd)
      {
        RxError(3, Cmd, Len, ChkSum);
        return false;
      }
      else if (RxBuff[3] != (Len))
      {
        RxError(4, Cmd, Len, ChkSum);
        return false;
      }
      
      for (i=0; i < Len+HeadLen; i++)  //  ChkSum excluded
      {
        ChkSum += (char)(RxBuff[i]);
      }
      ChkSum = ChkSum % 256;
      
      if (RxBuff[i] != ChkSum)
      {
        RxError(5, Cmd, Len, ChkSum);
        return false;
      }
      // image(LedYellowOn,Z(LYx),Z(LYy));
      return true;
  }
  return false;
}

/*-----------------------------------------------------------------------------*/
boolean RxArduinoData(char Cmd,int Len)
{
  int ChkSum = 0;
  int StartTime;
  int Timeout=1000; //ms
 
      StartTime=millis();
      while (ArduinoPort.available() <= (Len)) // wait data
      {
        if((millis()-StartTime) > Timeout)
        {
          ArduRxError(1, Cmd, Len, ChkSum);
          return false;
        }
      }
     
      for (i=0; i < Len + 1; i++)  // loop for all data expected and only for that
      {
        RxBuffA[i] = (ArduinoPort.read());
        /*
        print(i);
        print("  ");
        println(RxBuffA[i]); 
        */     
      }
      /*
      println( Int16toint32(((RxBuffA[4] << 8) + (RxBuffA[5]))));   
      println( Int16toint32(((RxBuffA[6] << 8) + (RxBuffA[7]))));
      println( Int16toint32(((RxBuffA[8] << 8) + (RxBuffA[9]))));   
      println( Int16toint32(((RxBuffA[10] << 8) + (RxBuffA[11]))));   
      */

      //println("-------");
      
      YawDes = (Int16toint32(((RxBuffA[8] << 8) + (RxBuffA[9]))))*180/511-180;   
      VelDes = (511-(Int16toint32(((RxBuffA[4] << 8) + (RxBuffA[5])))))*1200/511;
    
      if (RxBuffA[0] != '@')
      {
        ArduRxError(2, Cmd, Len, ChkSum);
        return false;
      }
      else if (RxBuffA[2] != Cmd)
      {
        ArduRxError(3, Cmd, Len, ChkSum);
        return false;
      }
      else if (RxBuffA[3] != (Len))
      {
        ArduRxError(4, Cmd, Len, ChkSum);
        return false;
      }
      
      for (i=0; i < 12; i++)  //  ChkSum excluded
      {
        ChkSum += (char)(RxBuffA[i]);
      }
      ChkSum = ChkSum % 256;
      
      if (RxBuffA[i] != ChkSum)
      {
        ArduRxError(5, Cmd, Len, ChkSum);
        return false;
      }
      // image(LedYellowOn,Z(LYx),Z(LYy));

      return true;
}

/*-----------------------------------------------------------------------------*/  
void TxData(int Id, int Cmd, int ValueLen, int IntFlag)
{
/* Transmit a string toward dsNavCon board
   for a detailed description of protocol, see descrEng.txt in dsPID33 folder
*/
  int TxBuffCount;
  int ChkSum = 0;
  int CmdLen = 0;
  
  if (!RS232Flag)  // RS232 not ready
  {
    return;
  }
  
  if (IntFlag == 0)  // byte value
  {
    CmdLen = ValueLen;  
    for (TxBuffCount = 0; TxBuffCount < ValueLen; TxBuffCount++)
    {
      TxBuff[(TxBuffCount*2)+TxHeadLen] = (byte)(TxIntValue[TxBuffCount]);
    }
  }
  
  if (IntFlag == 1)  // integer value
  {
    CmdLen = ValueLen*2;          // 1 int value = 2 bytes to transmit
    for (TxBuffCount = 0; TxBuffCount < ValueLen; TxBuffCount++)
    {
      TxBuff[(TxBuffCount*2)+TxHeadLen] = (byte)(TxIntValue[TxBuffCount] >> 8);
      TxBuff[(TxBuffCount*2)+TxHeadLen+1] = (byte)(TxIntValue[TxBuffCount]);
    }
  }
  
  if (IntFlag == 2) // long value
  {
    CmdLen = ValueLen*4;        // 1 long value = 4 bytes to transmit
    for (TxBuffCount = 0; TxBuffCount < ValueLen; TxBuffCount++)
    {
      TxBuff[(TxBuffCount*4)+TxHeadLen] = (byte)(TxIntValue[TxBuffCount] >> 24);
      TxBuff[(TxBuffCount*4)+TxHeadLen+1] = (byte)(TxIntValue[TxBuffCount] >> 16);
      TxBuff[(TxBuffCount*4)+TxHeadLen+2] = (byte)(TxIntValue[TxBuffCount] >> 8);
      TxBuff[(TxBuffCount*4)+TxHeadLen+3] = (byte)(TxIntValue[TxBuffCount]);
    }
  }
  
  TxBuff[0] = (byte)('@');
  TxBuff[1] = (byte)(Id);
  TxBuff[2] = (byte)(Cmd);
  TxBuff[3] = (byte)(CmdLen+1);  // included CheckSum

  for (i=0;i<(TxHeadLen+CmdLen);i++) 
  {
   ChkSum += TxBuff[i];
  }
  TxBuff[TxHeadLen+CmdLen] = (byte)(ChkSum);
  
  for (i=0;i<(TxHeadLen+CmdLen+1);i++) 
  {
    RS232Port.write(TxBuff[i]);
   }
      
  if (IntFlag != 3) TxFlag = true; // avoid to blink TX led for continuos send
}

void TxArduinoCmd(int Cmd)
{
  int ChkSum = 0;

  TxBuff[0] = (byte)('@');
  TxBuff[1] = (byte)(0);
  TxBuff[2] = (byte)(100);
  TxBuff[3] = (byte)(1);  // included CheckSum
  
  for (i=0; i < 4; i++) 
  {
   ChkSum += TxBuff[i];
  }
  TxBuff[4] = (byte)(ChkSum);
  
  for (i=0; i < (5); i++) 
  {
    ArduinoPort.write(TxBuff[i]);
  }
}


#include <custom_fakelag>
#include <console>

public Plugin:myinfo = 
{
  name = "Per-Player Fakelag V2",
  author = "CHIKKO",
  description = "Set a custom  latency per player GOOD",
  version = "1.0",
  url = "https://github.com/Sy1vian"
};


public OnPluginStart()
{
  RegAdminCmd("sm_fakelag", FakeLagCmd, view_as<int>(Admin_Config), "Set fake lag for a player");
  RegAdminCmd("sm_printlag", PrintLagCmd, view_as<int>(Admin_Config), "Print Current FakeLag");
}

public Action FakeLagCmd(int client, int args) {
  if(args < 1) {
    ReplyToCommand(client, "珠宝提醒请使用: sm_fakelag <target> <millseconds> 更多指令请访问GITHUB主页");
    return Plugin_Handled;
  }
  char targetStr[256];
  GetCmdArg(1, targetStr, sizeof(targetStr))
  int target = FindTarget(client, targetStr, true);
  if(target < 0) {
    ReplyToCommand(client, "珠宝提醒MADE服务器里哪有这个人？拿我玩是吧？ \"%s\"");
    return Plugin_Handled;
  }
  if(!IsClientInGame(target)) {
    ReplyToCommand(client, "珠宝提醒这个B %N 不在服务器里！", target);
    return Plugin_Handled;
  }
  if (IsFakeClient(target)) {
    ReplyToCommand(client, "珠宝提醒Player %N 为虚假的用户无法分配fakelag", target);
    return Plugin_Handled;
  }

  int lagAmount = GetCmdArgInt(2);
  CFakeLag_SetPlayerLatency(target, lagAmount * 1.0);
  ShowActivity2(client, "[珠宝大人提醒]", "给予了 %dms 的爱给 %N", lagAmount, target);
  return Plugin_Handled;
}


// DEBUG: See the value of s_FakeLag
public Action PrintLagCmd(int client, int args) {
	for(int i = 1; i < MaxClients; i++) {
    if(IsClientInGame(i) && !IsFakeClient(i))
    {
      ReplyToCommand(client, "%N: %fms", i, CFakeLag_GetPlayerLatency(i))
    }
  }

	return Plugin_Handled;
}


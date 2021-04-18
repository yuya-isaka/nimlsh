import strutils
import strformat
import os

var line: string        # 入力文字列
var status: int         # shell on, off

# do-whileテンプレート
template doWhile(a, b: untyped): untyped =
  b
  while a:
    b

var builsIncommand = ["cd", "pwd", "ls", "help", "exit"]

#-------------------------------------------------------

proc lshExecute(args: seq[string]) =
  if len(args) == 0:
    status = 1
    return

  status = 1
  case args[0]
  of "cd":
    if len(args) == 1:
      setCurrentDir(getHomeDir())
    elif len(args) == 2:
      if args[1] == "..":
        setCurrentDir(parentDir(getCurrentDir()))
      elif dirExists(args[1]):
        setCurrentDir(args[1])
      else:
        echo fmt"cd: no such file or directory: {args[1]}"
    else:
      echo "cd: too many arguments"
    return
  of "pwd":
    if len(args) == 1:
      echo getCurrentDir()
    else:
      echo "pwd: too many arguments"
    return
  of "ls":
    if len(args) == 1:
      for kind, path in walkDir(getCurrentDir()):
        echo path
    elif len(args) == 2:
      if dirExists(args[1]):
        for kind, path in walkDir(args[1]):
          echo path
      else:
        echo fmt"ls: no such file or directory: {args[1]}"
    else:
      echo "ls: too many arguments"
    return
  of "help":
    if len(args) == 1:
      echo "\n  [nimlsh]"
      echo "   Type program names and argumetns, and hit enter."
      echo "   The following are built in:"
      for i in builsIncommand:
        echo fmt"     {i}"
    else:
      echo "help: too many arguments"
    return
  of "exit":
    status = 0    # !ここで抜ける
    return
  else:
    echo fmt"nimlsh: command not found: {args[0]}"
    return

# lexer
proc tokenize(args: var seq[string]) =
    var i = 0
    while len(line) > i:

      # skip space
      if isSpaceAscii(line[i]) or line[i] == '\t':
        inc(i)
        continue

      # make string seq
      var tmp = $line[i]
      inc(i)
      while len(line) > i:
        if isSpaceAscii(line[i]) or line[i] == '\t':
          break
        tmp.add($line[i])
        inc(i)
      args.add(tmp)

      inc(i)

proc lshLoop() =

  doWhile bool(status):
    var args: seq[string]   # トークン列
    stdout.write fmt"\n[{getCurrentDir()}]$ "
    line = readLine(stdin)
    tokenize(args)
    lshExecute(args)

#--------------------------------------------------------

proc main() =

  lshLoop()

  quit(0)

main()
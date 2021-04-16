import strutils

var line: string
var args: seq[string]
var status: int

# do-whileテンプレート
template doWhile(a, b: untyped): untyped =
  b
  while a:
    b

#-------------------------------------------------------

# lexer
proc tokenize() =
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
    stdout.write "> "
    line = readLine(stdin)
    tokenize()

    echo args

#--------------------------------------------------------

proc main() =

  lshLoop()

  quit(0)

main()
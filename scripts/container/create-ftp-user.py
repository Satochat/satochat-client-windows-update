import sys
import pexpect

def main(argv):
    user = argv[0]
    password = sys.stdin.read()
    cmd = "pure-pw useradd '{0}' -f /etc/pure-ftpd/passwd/pureftpd.passwd -m -u ftpuser -d '/home/ftpusers/{0}'".format(user)
    child = pexpect.spawn(cmd)
    child.expect("Password: ")
    child.sendline(password)
    child.expect("Enter it again: ")
    child.sendline(password)
    child.expect(pexpect.EOF)
    child.wait()
    print(child.before)
    return child.exitstatus

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

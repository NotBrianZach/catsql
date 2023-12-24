{ lib, buildPythonPackage, fetchPypi, python, daff, openpyxl, six, sqlalchemy, parsedatetime, unicodecsv, psycopg2, mysqlclient, mock, nose }:

buildPythonPackage rec {
  pname = "catsql";
  version = "0.4.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "<insert-sha256-here>";
  };

  propagatedBuildInputs = [
    daff
    openpyxl
    six
    sqlalchemy
    parsedatetime
  ] ++ lib.optional (lib.versionAtLeast python.version "3") unicodecsv;

  checkInputs = [ mock nose ];
  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "Display a quick view of sql databases (and make quick edits)";
    homepage = "https://github.com/paulfitz/catsql";
    license = licenses.mit;
    maintainers = with maintainers; [ maintainers.example ];
  };
}

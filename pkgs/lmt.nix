{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "lmt";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "nat-418";
    repo = pname;
    rev = "v0.0.0";
    hash = "sha256-mzaDVV2ANRqj3qqK7pZ7+F8wWXhsYAQnwU/NHa9rqSs=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Literate markdown tangler";
    homepage = "https://github.com/nat-418/lmt";
    license = licenses.bsd0;
    maintainers = with maintainers; [ nat-418 ];
  };
}


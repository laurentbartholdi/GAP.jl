using BinDeps
using Compat

@BinDeps.setup

libgap = library_dependency("libgap")

GAP_VERSION = "4.8.3"

# package managers
#provides(AptGet, Dict("?"=>libgap))
#provides(Yum, "?", libgap)
#provides(Pacman, "?", libgap)

# build from source

provides(Sources, URI("https://bitbucket.org/vbraun/libgap/downloads/libgap-"*GAP_VERSION*".tar.gz"), libgap)
provides(BuildProcess, Autotools(libtarget = "src/libgap.la", include_dirs = ["."], configure_options = ["--with-gmp="*joinpath(JULIA_HOME,"..")]), libgap)

depsdir = BinDeps.depsdir(libgap)
run(`mkdir -p $(joinpath(depsdir,"downloads"))`)
gaptarball = joinpath(depsdir,"downloads/gap-"*GAP_VERSION*".tar.gz")
gapdir = joinpath(depsdir,"usr","share","gap-"*GAP_VERSION)
isfile(gaptarball) || download("http://www.gap-system.org/pub/gap/gap48/tar.gz/gap4r8p3_2016_03_19-22_17.tar.gz", gaptarball)
isdir(gapdir) || (run(`tar xfz $gaptarball -C $depsdir`); run(`mkdir -p $(joinpath(depsdir,"usr","share"))`); mv(joinpath(depsdir,"gap4r8"),gapdir))

@BinDeps.install Dict(:libgap => :libgap)

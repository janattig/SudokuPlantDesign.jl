###################
# ABSTRACT UPDATE
###################

abstract type AbstractUpdate end
export AbstractUpdate

function apply_update!(conf :: C, updt :: U) where {C <: CheckConfiguration, U <: AbstractUpdate}
    @error "Interface function not implemented yet"
end
export apply_update!
function reverse_update!(conf :: C, updt :: U) where {C <: CheckConfiguration, U <: AbstractUpdate}
    @error "Interface function not implemented yet"
end
export reverse_update!

function generate!(updt :: U, conf :: C) where {U <: AbstractUpdate, C <: CheckConfiguration}
    @error "Interface function not implemented yet"
end
export generate!

###################
# ABSTRACT UPDATE
###################

abstract type AbstractUpdate end

function apply_update!(conf :: C, updt :: U) where {C <: CheckConfiguration, U <: AbstractUpdate}
    @error "Interface function not implemented yet"
end
function reverse_update!(conf :: C, updt :: U) where {C <: CheckConfiguration, U <: AbstractUpdate}
    @error "Interface function not implemented yet"
end

function generate!(updt :: U, conf :: C) where {U <: AbstractUpdate, C <: CheckConfiguration}
    @error "Interface function not implemented yet"
end

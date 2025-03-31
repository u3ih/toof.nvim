return {
    '2kabhishek/exercism.nvim',
    cmd = {
        'ExercismLanguages',
        'ExercismList',
        'ExercismSubmit',
        'ExercismTest',
    },
    keys = {
        '<leader>exa',
        '<leader>exl',
        '<leader>exs',
        '<leader>ext',
    },
    dependencies = {
        '2kabhishek/utils.nvim',  -- required, for utility functions
        'stevearc/dressing.nvim', -- optional, highly recommended, for fuzzy select UI
        '2kabhishek/termim.nvim', -- optional, better UX for running tests
    },
    -- Add your custom configs here, keep it blank for default configs (required)
    opts = {},
}
